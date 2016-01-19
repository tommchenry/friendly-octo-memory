require_relative '../zeitgeist'

describe 'eat' do
  let(:headline) {HeadlineEater.new("a about Tom")}
  let(:headline2) {HeadlineEater.new("A About Tom")}
  it 'returns a string minus common words' do
    expect(headline.eat).to eq ("Tom")
  end

  it 'returns a string minus capitalized common words' do
    expect(headline2.eat).to eq ("Tom")
  end
end