require 'test/unit'

require 'rubygems'
require 'active_record'

$:.unshift File.dirname(__FILE__) + '/../lib'
require File.dirname(__FILE__) + '/../init'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")
 
# AR keeps printing annoying schema statements
$stdout = StringIO.new
 
def setup_db
  ActiveRecord::Base.logger
  ActiveRecord::Schema.define(:version => 1) do
    create_table :posts do |t|
      t.column :id, :integer
      t.column :title_en, :string
      t.column :title_pt, :string
      t.column :body_en, :text
      t.column :body_pt, :text
    end
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

setup_db
class Post < ActiveRecord::Base
  translated_attributes
end
teardown_db

class TranslatedAttributesTest < Test::Unit::TestCase
  def setup
    setup_db
    @post = Post.create(:title_en => 'Testing',
                        :title_pt => 'Testando',
                        :body_en  => 'to test a plugin ..',
                        :body_pt  => 'para testar um plugin ..')
  end
 
  def teardown
    teardown_db
  end
  
  def test_proper_title
    test_proper_title_for_locale('pt', @post.title_pt)
    test_proper_title_for_locale('en', @post.title_en)
  end
  
  private
    def test_proper_title_for_locale(locale, value)
      I18n.locale = locale
      assert_equal value, @post.title
    end
end