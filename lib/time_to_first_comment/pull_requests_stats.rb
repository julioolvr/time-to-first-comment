module TimeToFirstComment
  class PullRequestsStats
    attr_accessor :client

    # Creates a new instance of the stats generator.
    #
    # @param client [Octokit::Client]
    def initialize(client)
      self.client = client
    end

    # Gets the time until the first comment for a given repo's pull requests.
    #
    # @param repo [String] A string supported by {Octokit::Client} like 'username/repo'
    # @param options [Hash] Options for selecting the PRs to check.
    # @option options [String] :from PRs created starting from this date. The format is YYYY-MM-DD.
    # @option options [String] :to PRs created up to this date. The format is YYYY-MM-DD.
    # @return [Array<Array>] An array with tuples that include the pull request as the first parameter and the number of seconds
    #   until the first comment arrived as the second (`nil` if there are no comments).
    # @example Get the time to first comment for the PRs in the repo 'username/repo'
    #   client = TimeToFirstComment::PullRequestsStats.new(Octokit::Client.new)
    #   client.time_to_first_comment('username/repo', from: '2015-03-12', to: '2015-05-10')
    #   #=> [[<Sawyer::Resource ...>, 12000], [<Sawyer::Resource ...>, nil]]
    def time_to_first_comment(repo, options = {})
      repo_query = "repo:#{repo}"
      date_range_query = date_query(:created, options[:from], options[:to])

      pulls = client.search_issues("type:pr sort:updated #{repo_query} #{date_range_query}")[:items]

      pulls.map do |pull|
        [pull, seconds_until_first_comment(repo, pull)]
      end
    end

    private

    # Given a Pull Request ({Sawyer::Resource}) and the repo it belongs to it returns the number of seconds until the first
    # comment happened, or `nil` if there were none.
    #
    # @param repo [String] The name of the repo the PR belongs to.
    # @param pull [Sawyer::Resource] A Pull Request from {Octokit}.
    # @return [Fixnum] The number of seconds until that PRs first comment, or `nil`.
    def seconds_until_first_comment(repo, pull)
      issue_comments = pull.rels[:comments].get.data
      review_comments = client.review_comments(repo, pull.number)
      first_comment = (issue_comments + review_comments).sort_by(&:created_at).first
      first_comment.created_at - pull.created_at if first_comment
    end

    # Returns a query string for searching Github's API. It can be either for date created or updated, and with from and/or to
    # dates.
    #
    # @param [Symbol] type Either :created or :updated
    # @param [String] from Date from, the format is YYYY-MM-DD.
    # @param [String] to Date to, the format is YYYY-MM-DD.
    # @return [String] description A string for querying Github's API. An empty string if no date is provided.
    def date_query(type, from, to)
      if from && to
        dates = "#{from}..#{to}"
      elsif from
        dates = ">=#{from}"
      elsif to
        dates = "<=#{to}"
      else
        return ''
      end

      "#{type}:#{dates}"
    end
  end
end
