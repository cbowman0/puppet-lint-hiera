require 'spec_helper'

describe 'lookup_in_class_params' do
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
      expect(problems.size).to eq(0)
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
      expect(problems.size).to eq(0)
    end
  end

  context 'class with a lookup call in class' do
    let(:msg) { 'lookup() function call found in class.' }

    let(:code) do
      <<-EOS
        class lookup_call_class {
          file { '/tmp/foo':
            content => lookup('some_key'),
          }
        }
      EOS
    end

    it 'should not detect any problems' do
      expect(problems.size).to eq(0)
    end
  end

  context 'profile with a lookup call in class' do
    let(:msg) { 'lookup() function call found in profile class. Only use in profile params.' }

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
      expect(problems.size).to eq(0)
    end
  end

  # and these should cause failiures
  context 'class with a lookup call in params' do
    let(:msg) { 'lookup() function call found in class params.' }

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
      expect(problems.size).to eq(1)
    end

    it 'should create an error' do
      expect(problems).to contain_error(msg).on_line(2).in_column(29)
    end
  end

   # Defined types
  context 'Define with a lookup call in params' do
    let(:msg) { 'lookup() function call found in defined type params.' }

    let(:code) do
      <<-EOS
        define lookup_call_params (
          $content = lookup('some_key')
        ) {
          file { '/tmp/foo':
            content => $content,
          }
        }
      EOS
    end

    it 'should not detect a single problem' do
      expect(problems.size).to eq(0)
    end

  end

end
