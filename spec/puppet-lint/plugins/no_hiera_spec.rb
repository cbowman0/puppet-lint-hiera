require 'spec_helper'

describe 'no_hiera' do
  context 'class with no hiera calls' do
    let(:code) do
      <<-EOS
        class no_hiera_calls {
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

  # and these should cause failiures

  context 'class with a hiera call in class' do
    let(:msg) { 'hiera() function call. Use lookup() instead.' }

    let(:code) do
      <<-EOS
        class hiera_call {
          file { '/tmp/foo':
            content => hiera('some_key'),
          }
        }
      EOS
    end

    it 'should detect a single problem' do
      expect(problems).to have(1).problem
    end

    it 'should create an error' do
      expect(problems).to contain_error(msg).on_line(3).in_column(30)
    end
  end

  context 'class with a hiera call in params' do
    let(:msg) { 'hiera() function call. Use lookup() instead.' }

    let(:code) do
      <<-EOS
        class hiera_call (
          $content = hiera('some_key')
        ){
          file { '/tmp/foo':
            content => $content,
          }
        }
      EOS
    end

    it 'should detect a single problem' do
      expect(problems).to have(1).problem
    end

    it 'should create an error' do
      expect(problems).to contain_error(msg).on_line(2).in_column(28)
    end
  end

end
