require 'spec_helper'

def assert_escape_match(md, mathjax)
  converted = MathJaxYard::check_escape_match(md)
  expect(converted).to eq(mathjax)
end
def assert_multiple_match(md, mathjax)
  converted = MathJaxYard::check_multiple_match(md,'dummy')
  expect(converted).to eq(mathjax)
end

describe MathJaxYard do
  it 'has a version number' do
    expect(MathJaxYard::VERSION).not_to be nil
  end

  it 'match escape' do
    md='\$test\$'
    mathjax=''
    assert_escape_match(md,mathjax)
  end
end
