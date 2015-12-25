require 'spec_helper'

describe TimeToFirstComment::PullRequestsStats do
  describe '#time_to_first_comment' do
    let(:stats) { TimeToFirstComment::PullRequestsStats.new(client) }
    let(:client) { double('Octokit::Client', pulls: [pull]) }
    let(:pull) { double(rels: comments, created_at: Time.now - 12_000) }
    let(:comments) { { comments: issue_comments_rel, review_comments: review_comments_rel } }
    let(:issue_comments_rel) { double(get: double(data: issue_comments)) }
    let(:review_comments_rel) { double(get: double(data: review_comments)) }

    subject { stats.time_to_first_comment('username/repo').first }

    context 'for a pull request without comments' do
      let(:issue_comments) { [] }
      let(:review_comments) { [] }

      it 'returns nil for the number of seconds' do
        expect(subject).to eq [pull, nil]
      end
    end

    context 'for a pull request with only review comments' do
      let(:issue_comments) { [] }
      let(:review_comments) { [double(created_at: Time.now)] }

      it 'returns the number of seconds until the first review comment' do
        expect(subject).to eq [pull, review_comments.first.created_at - pull.created_at]
      end
    end

    context 'for a pull request with only issue comments' do
      let(:issue_comments) { [double(created_at: Time.now)] }
      let(:review_comments) { [] }

      it 'returns the number of seconds until the first issue comment' do
        expect(subject).to eq [pull, issue_comments.first.created_at - pull.created_at]
      end
    end

    context 'for a pull request with both type of comments' do
      context 'when the issue comment happened first' do
        let(:issue_comments) { [double(created_at: Time.now - 1000)] }
        let(:review_comments) { [double(created_at: Time.now)] }

        it 'returns the number of seconds until the first issue comment' do
          expect(subject).to eq [pull, issue_comments.first.created_at - pull.created_at]
        end
      end

      context 'when the review comment happened first' do
        let(:issue_comments) { [double(created_at: Time.now)] }
        let(:review_comments) { [double(created_at: Time.now - 1000)] }

        it 'returns the number of seconds until the first review comment' do
          expect(subject).to eq [pull, review_comments.first.created_at - pull.created_at]
        end
      end
    end
  end
end
