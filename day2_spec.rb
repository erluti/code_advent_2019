require './day2.rb'
require 'rspec'

describe IntcodeProgram do
  it '1,0,0,0,99 becomes 2,0,0,0,99' do
    expect(IntcodeProgram.new('1,0,0,0,99').run).to eq '2,0,0,0,99'
  end
  it '2,3,0,3,99 becomes 2,3,0,6,99' do
    expect(IntcodeProgram.new('2,3,0,3,99').run).to eq '2,3,0,6,99'
  end
  it '2,4,4,5,99,0 becomes 2,4,4,5,99,9801' do
    expect(IntcodeProgram.new('2,4,4,5,99,0').run).to eq '2,4,4,5,99,9801'
  end
  it '1,1,1,4,99,5,6,0,99 becomes 30,1,1,4,2,5,6,0,99' do
    expect(IntcodeProgram.new('1,1,1,4,99,5,6,0,99').run).to eq '30,1,1,4,2,5,6,0,99'
  end
  it 'supports the example' do
    expect(IntcodeProgram.new('1,9,10,3,2,3,11,0,99,30,40,50').run).to eq '3500,9,10,70,2,3,11,0,99,30,40,50'
  end
end