class PullRequestsStats
  attr_accessor :client

  def initialize(client)
    self.client = client
  end

  def time_to_first_comment(repo)
    pulls = client.pulls(repo, state: :all)

    pulls.map do |pull|
      issue_comments = pull.rels[:comments].get.data
      review_comments = pull.rels[:review_comments].get.data
      first_comment = (issue_comments + review_comments).sort_by(&:created_at).first
      seconds = first_comment.created_at - pull.created_at if first_comment

      [pull, seconds]
    end
  end
end
