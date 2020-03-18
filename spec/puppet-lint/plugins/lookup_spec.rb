require 'spec_helper'

describe 'lookup' do
  context 'class with no lookup calls' do
    let(:code) do
      <<-EOS
        class no_lookup_calls {
          file { '/tmp/foo':
            content => 'bar',
          }
        }
      EOS
    end

    it 'should not detect any problems' do
      expect(problems).to have(0).problems
    end
  end

  context 'profile with a lookup call in params' do
    let(:code) do
      <<-EOS
        class profile::lookup_call_params (
          $content = lookup('some_key')
        ) {
          file { '/tmp/foo':
            content => $content,
          }
        }
      EOS
    end

    it 'should not detect any problems' do
      expect(problems).to have(0).problems
    end
  end

  context 'profile with a lookup call in class' do
    let(:code) do
      <<-EOS
        class profile::lookup_call_class {
          file { '/tmp/foo':
            content => lookup('some_key'),
          }
        }
      EOS
    end

    it 'should not detect any problems' do
      expect(problems).to have(0).problems
    end
  end

  # and these should cause failiures

  context 'class with a lookup call in params' do
    let(:msg) { 'lookup() function call. Dont do this!' }

    let(:code) do
      <<-EOS
        class lookup_call_params (
          $content = lookup('some_key')
        ) {
          file { '/tmp/foo':
            content => $content,
          }
        }
      EOS
    end

    it 'should detect a single problem' do
      expect(problems).to have(1).problems
    end

    it 'should create an error' do
      expect(problems).to contain_error(msg).on_line(3).in_column(31)
    end
  end

  context 'class with a lookup call in class' do
    let(:msg) { 'lookup() function call. Dont do this!' }

    let(:code) do
      <<-EOS
        class lookup_call_class {
          file { '/tmp/foo':
            content => lookup('some_key'),
          }
        }
      EOS
    end

    it 'should detect a single problem' do
      expect(problems).to have(1).problem
    end

    it 'should create an error' do
      expect(problems).to contain_error(msg).on_line(3).in_column(31)
    end
  end
end
