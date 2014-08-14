require 'spec_helper'
require 'parser/current'
require 'unparser'
require 'lib/active_mocker/ruby_parse'
require 'active_support/core_ext/object/try'

describe ActiveMocker::RubyParse do

  describe '#class_name' do

    it 'returns the parent class as a symbol' do
      subject = described_class.new <<-RUBY
      require 'uri-open'

      class A < B
        def method
        end
      end
      RUBY
      expect(subject.class_name).to eq 'A'
    end

  end

  describe '#parent_class_name' do

    it 'returns the parent class as a symbol' do
      subject = described_class.new <<-RUBY
      require 'uri-open'
      class A < B
        def method
        end
      end
      RUBY
      expect(subject.parent_class_name).to eq 'B'
    end

    it 'returns the parent class as a symbol with modules' do
      subject = described_class.new <<-RUBY
      class A < B::C
        def method
        end
      end
      RUBY
      expect(subject.parent_class_name).to eq 'B::C'
    end

  end

  describe '#has_parent_class?' do

    it 'has parent class' do
      subject = described_class.new <<-RUBY
      require 'uri-open'
      class A < B
        def method
        end
      end
      RUBY
      expect(subject.has_parent_class?).to eq true

      subject = described_class.new <<-RUBY
      class A < B
        def method
        end
      end
      RUBY
      expect(subject.has_parent_class?).to eq true
    end

    it 'has no parent class' do
      subject = described_class.new <<-RUBY
      require 'uri-open'
      class A
        def method
        end
      end
      RUBY
      expect(subject.has_parent_class?).to eq false

      subject = described_class.new <<-RUBY
      class A
        def method
        end
      end
      RUBY
      expect(subject.has_parent_class?).to eq false
    end

    it 'its not a class' do
      subject = described_class.new <<-RUBY
      def method

      end
      RUBY
      expect(subject.has_parent_class?).to eq false

    end

  end

  describe '#modify_parent_class' do

    it 'will change parent class const' do
      subject = described_class.new <<-RUBY
      class A < B
        def method(name:)
        end
      end
      RUBY
      expect(subject.modify_parent_class('C')).to eq "class A < C\n  def method(name:)\n  end\nend"

      subject = described_class.new <<-RUBY
      require 'uri-open'
      class A < B
        def method(name:)
        end
      end
      RUBY
      expect(subject.modify_parent_class('C')).to eq "class A < C\n  def method(name:)\n  end\nend"
    end

    it 'will change parent class const with module' do
      subject = described_class.new <<-RUBY
      class A < B::D::C
        def method(name:)
        end
      end
      RUBY
      expect(subject.modify_parent_class('X::Y')).to eq "class A < X::Y\n  def method(name:)\n  end\nend"
    end

    it 'if non set it will add the parent' do
      subject = described_class.new <<-RUBY
      class A
        def method(*args)
        end
      end
      RUBY
      expect(subject.modify_parent_class('C')).to eq "class A < C\n  def method(*args)\n  end\nend"
    end

  end

  describe '#change_class_name' do

    it 'will change the class constant' do
      subject = described_class.new <<-RUBY
      class A
        def method(options={})
        end
      end
      RUBY
      expect(subject.change_class_name('C')).to eq "class C\n  def method(options = {})\n  end\nend"
    end

  end

  describe '#is_class?' do

    it 'is a class' do
      subject = described_class.new <<-RUBY
      class A
        def method(options={})
        end
      end
      RUBY
      expect(subject.is_class?).to eq true
    end


    it 'is not a class' do
      subject = described_class.new <<-RUBY
        def method(options={})
        end
      RUBY
      expect(subject.is_class?).to eq false
    end
  end

end
