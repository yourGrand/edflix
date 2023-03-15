
require_relative "../spec_helper"
require "logger"
require "sequel"

describe "DB" do
  let(:type) { "test" }
  let(:db_path) { File.dirname(__FILE__) }
  let(:db) { "#{db_path}/#{type}.sqlite3" }
  let(:log_path) { "#{File.dirname(__FILE__)}/../log/" }
  let(:log) { "#{log_path}/#{type}.log" }

  before do
    Dir.mkdir(log_path) unless File.exist?(log_path)
    @db_instance = Sequel.sqlite(db, logger: Logger.new(log))
  end

  it "should be a Sequel database instance" do
    expect(@db_instance).to be_a(Sequel::SQLite::Database)
  end

  it "should have a logger set up" do
    expect(@db_instance.loggers).not_to be (nil)
  end
end



