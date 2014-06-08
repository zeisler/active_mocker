require 'rspec'
require 'rspec/given'
$:.unshift File.expand_path('../../../lib', __FILE__)
require 'active_mocker/reparameterize'

describe ActiveMocker::Reparameterize do

  describe '::call' do

    describe 'create parameter arguments' do

      context 'keyreq' do

        Given(:parameters) { [[:keyreq, 'named_param']] }

        When(:call) { described_class.call(parameters) }

        Then { expect(call).to eq('named_param:') }

      end

      context 'key' do

        Given(:parameters) { [[:key, 'named_param']] }

        When (:call) { described_class.call(parameters) }

        Then { expect(call).to eq('named_param: nil') }

      end

      context 'req' do

        Given(:parameters) { [[:req, 'req_param']] }

        When (:call) { described_class.call(parameters) }

        Then { expect(call).to eq('req_param') }

      end

      context 'rest' do

        Given(:parameters) { [[:rest, 'rest_param']] }

        When (:call) { described_class.call(parameters) }

        Then { expect(call).to eq('*rest_param') }

      end


      context 'opt' do

        Given(:parameters) { [[:opt, 'opt_param']] }

        When(:call) { described_class.call(parameters) }

        Then { expect(call).to eq('opt_param=nil') }

      end

      context 'req, rest' do

        Given(:parameters) { [[:req, 'req_param'], [:rest, 'rest_param']] }

        When(:call) { described_class.call(parameters) }

        Then { expect(call).to eq('req_param, *rest_param') }

      end

      context 'req, opt' do

        Given(:parameters) { [[:req, 'req_param'], [:opt, 'opt_param']] }

        When(:call) { described_class.call(parameters) }

        Then { expect(call).to eq('req_param, opt_param=nil') }

      end

      context 'key, keyreq' do

        Given(:parameters) { [[:key, 'named_param'], [:keyreq, 'named_param']] }

        When(:call) { described_class.call(parameters) }

        Then { expect(call).to eq('named_param: nil, named_param:') }

      end

      context 'rep, key' do

        Given(:parameters) { [[:key, 'key_param'], [:req, 'req_param']] }

        When (:call) { described_class.call(parameters) }

        Then { expect(call).to eq('key_param: nil, req_param') }

      end

    end

    context 'create a parameter passable list' do

      context 'keyreq' do

        Given(:parameters) { [[:keyreq, 'named_param']] }

        When (:call) { described_class.call(parameters, param_list: true) }

        Then { expect(call).to eq('named_param: named_param') }

      end

      context 'key' do

        Given(:parameters) { [[:key, 'named_param']] }

        When (:call) { described_class.call(parameters, param_list: true) }

        Then { expect(call).to eq('named_param: named_param') }

      end

      context 'req' do

        Given(:parameters) { [[:req, 'req_param']] }

        When (:call) { described_class.call(parameters, param_list: true) }

        Then { expect(call).to eq('req_param') }

      end

      context 'rest' do

        Given(:parameters) { [[:rest, 'rest_param']] }

        When (:call) { described_class.call(parameters, param_list: true) }

        Then { expect(call).to eq('rest_param') }

      end


      context 'opt' do

        Given(:parameters) { [[:opt, 'opt_param']] }

        When (:call) { described_class.call(parameters, param_list: true) }

        Then { expect(call).to eq('opt_param') }

      end

      context 'req, rest' do

        Given(:parameters) { [[:req, 'req_param'], [:rest, 'rest_param']] }

        When (:call) { described_class.call(parameters, param_list: true) }

        Then { expect(call).to eq('req_param, rest_param') }

      end

      context 'req, opt' do

        Given(:parameters) { [[:req, 'req_param'], [:opt, 'opt_param']] }

        When (:call) { described_class.call(parameters, param_list: true) }

        Then { expect(call).to eq('req_param, opt_param') }

      end

      context 'key, keyreq' do

        Given(:parameters) { [[:key, 'key_param'], [:keyreq, 'keyreq_param']] }

        When (:call) { described_class.call(parameters, param_list: true) }

        Then { expect(call).to eq('key_param: key_param, keyreq_param: keyreq_param') }

      end

      context 'rep, key' do

        Given(:parameters) { [[:key, 'key_param'], [:req, 'req_param']] }

        When (:call) { described_class.call(parameters, param_list: true) }

        Then { expect(call).to eq('key_param: key_param, req_param') }

      end

    end

  end

end