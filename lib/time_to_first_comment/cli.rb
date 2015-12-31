require 'octokit'
require 'chronic_duration'
require 'slop'

module TimeToFirstComment
  class Cli
    def respond(arguments)
      opts = Slop.parse(arguments) do
        on :r, :repo=, 'Repository to look for PRs on'
        on :from=, 'PRs created since this date - YYYY-MM-DD', argument: :optional
        on :to=, 'PRs created up to this date - YYYY-MM-DD', argument: :optional
        on :e, :endpoint=, 'Custom API endpoint to connect to Github Enterprise', argument: :optional
        on :t, :token=, 'Access Token to query Github as a specific user', argument: :optional
      end

      unless opts.map(&:value).compact.any?
        puts opts.help
        return
      end

      if opts.missing.include?('repo')
        puts 'Missing repository.'
        puts opts.help
        return
      end

      stats = TimeToFirstComment::PullRequestsStats.new(octokit_client(endpoint: opts[:endpoint], token: opts[:token]))

      stats.time_to_first_comment(opts[:repo], from: opts[:from], to: opts[:to]).each do |pull, seconds|
        if seconds
          puts %(#{pull.title}: #{ChronicDuration.output(seconds)} until first comment.)
        else
          puts %(#{pull.title}: No comments yet.)
        end
      end
    end

    private

    def octokit_client(endpoint:, token:)
      options = {}
      options[:api_endpoint] = endpoint if endpoint
      options[:access_token] = token if token
      Octokit::Client.new(options)
    end
  end
end
