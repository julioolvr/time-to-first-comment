require 'spec_helper'

describe TimeToFirstComment::Cli do
  describe '#respond' do
    let(:stats) { double(time_to_first_comment: []) }
    let(:repo_name) { 'someuser/somerepo' }
    subject { TimeToFirstComment::Cli.new }

    before do
      allow(TimeToFirstComment::PullRequestsStats).to receive(:new).and_return(stats)
    end

    it 'doesn\'t try to get stats if no parameters are passed' do
      expect(stats).not_to receive(:time_to_first_comment)
      subject.respond([])
    end

    it 'doesn\'t try to get stats if no repo is passed' do
      expect(stats).not_to receive(:time_to_first_comment)
      subject.respond(['--from', '2015-07-12'])
    end

    it 'uses the repo passed as an option to fetch the stats' do
      expect(stats).to receive(:time_to_first_comment).with(repo_name, from: nil, to: nil)
      subject.respond(['--repo', repo_name])
    end

    it 'uses the `from` date passed as a parameter' do
      from_date = '2015-07-12'
      expect(stats).to receive(:time_to_first_comment).with(repo_name, from: from_date, to: nil)
      subject.respond(['--repo', repo_name, '--from', from_date])
    end

    it 'uses the `to` date passed as a parameter' do
      to_date = '2015-07-12'
      expect(stats).to receive(:time_to_first_comment).with(repo_name, from: nil, to: to_date)
      subject.respond(['--repo', repo_name, '--to', to_date])
    end

    it 'outputs the time to first comment for the PRs'
  end
end
