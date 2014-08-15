require 'spec/spec_helper'
require 'active_mocker/reparameterize'

describe ActiveMocker::Reparameterize do

  describe '::call' do

    describe 'create parameter arguments' do

      context 'keyreq' do

        let(:parameters) { [[:keyreq, 'named_param']] }

        let(:call) { described_class.call(parameters) }

        it {expect(call).to eq('named_param:')}

      end

      context 'key' do

        let(:parameters) { [[:key, 'named_param']] }

        let (:call) { described_class.call(parameters) }

        it { expect(call).to eq('named_param: nil') }

      end

      context 'req' do

        let(:parameters) { [[:req, 'req_param']] }

        let (:call) { described_class.call(parameters) }

        it { expect(call).to eq('req_param') }

      end

      context 'rest' do

        let(:parameters) { [[:rest, 'rest_param']] }

        let (:call) { described_class.call(parameters) }

        it { expect(call).to eq('*rest_param') }

      end


      context 'opt' do

        let(:parameters) { [[:opt, 'opt_param']] }

        let(:call) { described_class.call(parameters) }

        it { expect(call).to eq('opt_param=nil') }

      end

      context 'req, rest' do

        let(:parameters) { [[:req, 'req_param'], [:rest, 'rest_param']] }

        let(:call) { described_class.call(parameters) }

        it { expect(call).to eq('req_param, *rest_param') }

      end

      context 'req, opt' do

        let(:parameters) { [[:req, 'req_param'], [:opt, 'opt_param']] }

        let(:call) { described_class.call(parameters) }

        it { expect(call).to eq('req_param, opt_param=nil') }

      end

      context 'key, keyreq' do

        let(:parameters) { [[:key, 'named_param'], [:keyreq, 'named_param']] }

        let(:call) { described_class.call(parameters) }

        it { expect(call).to eq('named_param: nil, named_param:') }

      end

      context 'rep, key' do

        let(:parameters) { [[:key, 'key_param'], [:req, 'req_param']] }

        let (:call) { described_class.call(parameters) }

        it { expect(call).to eq('key_param: nil, req_param') }

      end

    end

    context 'create a parameter passable list' do

      context 'keyreq' do

        let(:parameters) { [[:keyreq, 'named_param']] }

        let (:call) { described_class.call(parameters, param_list: true) }

        it { expect(call).to eq('named_param: named_param') }

      end

      context 'key' do

        let(:parameters) { [[:key, 'named_param']] }

        let (:call) { described_class.call(parameters, param_list: true) }

        it { expect(call).to eq('named_param: named_param') }

      end

      context 'req' do

        let(:parameters) { [[:req, 'req_param']] }

        let (:call) { described_class.call(parameters, param_list: true) }

        it { expect(call).to eq('req_param') }

      end

      context 'rest' do

        let(:parameters) { [[:rest, 'rest_param']] }

        let (:call) { described_class.call(parameters, param_list: true) }

        it { expect(call).to eq('rest_param') }

      end


      context 'opt' do

        let(:parameters) { [[:opt, 'opt_param']] }

        let (:call) { described_class.call(parameters, param_list: true) }

        it { expect(call).to eq('opt_param') }

      end

      context 'req, rest' do

        let(:parameters) { [[:req, 'req_param'], [:rest, 'rest_param']] }

        let (:call) { described_class.call(parameters, param_list: true) }

        it { expect(call).to eq('req_param, rest_param') }

      end

      context 'req, opt' do

        let(:parameters) { [[:req, 'req_param'], [:opt, 'opt_param']] }

        let (:call) { described_class.call(parameters, param_list: true) }

        it { expect(call).to eq('req_param, opt_param') }

      end

      context 'key, keyreq' do

        let(:parameters) { [[:key, 'key_param'], [:keyreq, 'keyreq_param']] }

        let (:call) { described_class.call(parameters, param_list: true) }

        it { expect(call).to eq('key_param: key_param, keyreq_param: keyreq_param') }

      end

      context 'rep, key' do

        let(:parameters) { [[:key, 'key_param'], [:req, 'req_param']] }

        let (:call) { described_class.call(parameters, param_list: true) }

        it { expect(call).to eq('key_param: key_param, req_param') }

      end

    end

  end

end