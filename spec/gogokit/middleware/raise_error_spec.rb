require 'spec_helper'

describe GogoKit::Middleware::RaiseError do
  def connection
    Faraday.new do |c|
      c.use described_class

      c.adapter :test do |stub|
        yield(stub) if block_given?
      end
    end
  end

  [200, 201, 202, 204, 301, 302, 303, 307].each do |status|
    context "for an HTTP #{status} response" do
      it 'should not raise an error' do
        expect do
          connection do |stub|
            stub.get('/') { [status, {}, ''] }
          end.get('/')
        end.not_to raise_error
      end
    end
  end

  [400, 401, 403, 404, 405, 409, 429, 500, 501].each do |status|
    context "for an HTTP #{status} response" do
      it 'should raise a GogoKit::ApiError'do
        expect do
          connection do |stub|
            stub.get('/') { [status, {}, ''] }
          end.get('/')
        end.to raise_error GogoKit::ApiError
      end
    end
  end
end
