require 'octokit'
require 'chronic_duration'

repo = 'julioolvr/count-to-1000'
client = Octokit::Client.new

pulls = client.pulls(repo, state: :all)

pulls.each do |pull|
  puts "Checking comments for #{pull.title}"
  issue_comments = pull.rels[:comments].get.data
  review_comments = pull.rels[:review_comments].get.data
  first_comment = (issue_comments + review_comments).sort_by(&:created_at).first

  if first_comment
    seconds = first_comment.created_at - pull.created_at
    puts "Time until first comment was #{ChronicDuration.output(seconds)}"
  else
    puts 'No comments yet'
  end
end
