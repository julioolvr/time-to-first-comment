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
    # @return [Array<Array>] An array with tuples that include the pull request as the first parameter and the number of seconds
    #   until the first comment arrived as the second (`nil` if there are no comments).
    # @example Get the time to first comment for the PRs in the repo 'username/repo'
    #   client = TimeToFirstComment::PullRequestsStats.new(Octokit::Client.new)
    #   client.time_to_first_comment('username/repo')
    #   #=> [[<Sawyer::Resource ...>, 12000], [<Sawyer::Resource ...>, nil]]
    def time_to_first_comment(repo)
      pulls = client.pulls(repo, state: :all)

      pulls.map do |pull|
        [pull, seconds_until_first_comment(pull)]
      end
    end

    private

    # Given a Pull Request ({Sawyer::Resource}) it returns the number of seconds until the first comment happened,
    # or `nil` if there were none.
    #
    # @param pull [Sawyer::Resource] A Pull Request from {Octokit}
    # @return [Fixnum] The number of seconds until that PRs first comment, or `nil`.
    def seconds_until_first_comment(pull)
      issue_comments = pull.rels[:comments].get.data
      review_comments = pull.rels[:review_comments].get.data
      first_comment = (issue_comments + review_comments).sort_by(&:created_at).first
      first_comment.created_at - pull.created_at if first_comment
    end
  end
end
