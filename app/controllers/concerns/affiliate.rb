module Affiliate
  extend ActiveSupport::Concern

  class Process
    attr_reader :chat_id, :updated_url, :error

    def initialize(chat_id)
      @chat_id = chat_id
      @error = false
    end

    def individual_url(url)
      @updated_url = url
      case updated_url
      when /amazon.in/
        amazon(url, short: false)
      when /amzn.to/, /amzn.in/
        amazon(url, short: true)
      when /flipkart.com/
        flipkart(url, short: false)
      when /fkrt.it/
        flipkart(url, short: true)
      else
        redirection(url)
      end
    end

    private

    def amazon(url, short: false)
      fetch_url if short
      clean_url
      amzn_id = Cache.redis.get("#{chat_id}:amzn_id")
      add_tracking_id(amzn_id, 'tag')
      @updated_url = shorten_url(updated_url)
    end

    def flipkart(url, short: false)
      fetch_url if short
      clean_url
      fkrt_id = Cache.redis.get("#{chat_id}:fkrt_id")
      add_tracking_id(fkrt_id, 'affid')
      @updated_url = shorten_url(updated_url, flipkart: true)
    end

    def redirection(url)
      @error = true
      @updated_url = "URL Not Supported: #{url}"
    end

    def fetch_url
      response = HTTParty.get(@updated_url, follow_redirects: false)
      if response.code == 301
        @updated_url = response.headers[:location]
      else
        response.request.last_uri.to_s
      end
    end

    def clean_url
      url = @updated_url.to_s
      url = remove_existing_tracking_ids(url)
      uri = Addressable::URI.parse(url)
      @updated_url = uri.to_s.gsub('&amp;', '&')
    end

    def remove_existing_tracking_ids(url)
      uri = url.split('?')
      url_query = []
      unless uri[1].nil?
        url_query = uri[1].split('&').reject do |param|
          param.match(/^aff.*=/) ||
            param.match(/^tag=/) ||
            param.match(/^ascsubtag=/) ||
            param.match(/^vsugd.*=/)
        end
      end
      "#{uri.first}?#{url_query.join('&')}"
    end

    def add_tracking_id(tracking_id, tag)
      @updated_url = "#{@updated_url}?" unless @updated_url.include?('?')
      @updated_url = "#{@updated_url}&#{tag}=#{tracking_id}"
    end

    def shorten_url(url, flipkart: false)
      if flipkart
        fkrt_url = "https://affiliate.flipkart.com/a_url_shorten?url=#{CGI.escape(url)}"
        res = HTTParty.get(fkrt_url, follow_redirects: false)
        res['response']['shortened_url']
      else
        bitly_id = Cache.redis.get("#{chat_id}:bitly_id")
        BitlyUrl.new(bitly_id, updated_url).short_url
      end
    rescue StandardError => e
      @error = true
      puts e.inspect
      e.inspect
    end
  end
end