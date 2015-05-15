require 'spec_helper'
require 'active_mocker/reparameterize'

describe ActiveMocker::Reparameterize do

  describe '::method_arguments' do

    describe 'create parameter arguments' do

      let(:subject) { described_class.method_arguments(parameters) }
      let(:parameters) { method(:example).parameters }

      context 'keyreq' do

        def example(named_param:)
        end

        it { expect(subject).to eq('named_param:') }

      end

      context 'key' do

        def example(named_param: nil)
        end

        it { expect(subject).to eq('named_param: nil') }

      end

      context 'req' do

        def example(req_param)
        end

        it { expect(subject).to eq('req_param') }

      end

      context 'rest' do

        def example(*rest_param)
        end

        it { expect(subject).to eq('*rest_param') }

      end

      context 'opt' do

        def example(opt_param=nil)
        end

        it { expect(subject).to eq('opt_param=nil') }

      end

      context 'req, rest' do

        def example(req_param, *rest_param)
        end

        it { expect(subject).to eq('req_param, *rest_param') }

      end

      context 'req, opt' do

        def example(req_param, opt_param=nil)
        end

        it { expect(subject).to eq('req_param, opt_param=nil') }

      end

      context 'key, keyreq' do

        def example(named_param_req: nil, named_param:)
        end

        it { expect(subject).to eq('named_param:, named_param_req: nil') }

      end

      context 'rep, key' do

        def example(req_param, key_param: nil)
        end

        it { expect(subject).to eq('req_param, key_param: nil') }

      end

    end

  end

  describe '::method_parameters' do

    subject { described_class.method_parameters(parameters) }
    let(:parameters) { method(:example).parameters }

    context 'keyreq' do

      def example(named_param:)
      end

      it { expect(subject).to eq('named_param: named_param') }

    end

    context 'key' do

      def example(named_param: nil)
      end

      it { expect(subject).to eq('named_param: named_param') }

    end

    context 'req' do

      def example(req_param)
      end

      it { expect(subject).to eq('req_param') }

    end

    context 'rest' do

      def example(*rest_param)
      end

      it { expect(subject).to eq('rest_param') }

    end

    context 'opt' do

      def example(opt_param=nil)
      end

      it { expect(subject).to eq('opt_param') }

    end

    context 'req, rest' do

      def example(req_param, *rest_param)
      end

      it { expect(subject).to eq('req_param, rest_param') }

    end

    context 'req, opt' do

      def example(req_param, opt_param=nil)
      end

      it { expect(subject).to eq('req_param, opt_param') }

    end

    context 'key, keyreq' do

      def example(named_param_req: nil, named_param:)
      end

      it { expect(subject).to eq('named_param: named_param, named_param_req: named_param_req') }

    end

    context 'rep, key' do

      def example(req_param, key_param: nil)
      end

      it { expect(subject).to eq('req_param, key_param: key_param') }

    end

  end

end