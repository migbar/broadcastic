require 'spec_helper'

describe Broadcastic::Broadcast do

	context "with a valid event" do
		it "undertstands the broadcast method and not raise an exception" do
			expect  {
				class Product < ActiveRecord::Base
					broadcast :changes
				end
			}.to_not raise_error(NoMethodError, /undefined method `broadcast'/)
		end

	end

	context "with an invalid event" do
		it "raises an exception" do
			expect  {
				class Product < ActiveRecord::Base
					broadcast :some_non_existing_callback
				end
			}.to raise_error(Broadcastic::InvalidCallbackName)
		end
	end

	context "with an invalid recipient" do

		it "Should raise an exception about the recipient method being invalid" do

			expect  {
				class Product < ActiveRecord::Base
					broadcast :creations, to: :some_recipient
				end
				p = Product.create(name: "foo")
			}.to raise_error(NoMethodError, /undefined method `some_recipient'/)
		end
	end

	context "with an valid recipient" do

		it "Should not raise an exception about the recipient method being invalid" do

			expect  {
				class Product < ActiveRecord::Base
					broadcast :creations, to: :vendors

					def vendors
						["vendors/1", "vendors/2"]
					end
				end
				Broadcaster.stub(:broadcast)
				p = Product.create(name: "foo")
			}.to_not raise_error(NoMethodError, /undefined method `vendors'/)
		end
	end

	context "without options" do

		it "should send the appropriate message to Callbacks for each callback type" do
			Broadcastic::Callbacks.should_receive(:broadcast_changes).with(Product, {})
			class Product < ActiveRecord::Base
				broadcast :changes
			end
		end

		it "should send the appropriate message to Callbacks for each callback type" do
			Broadcastic::Callbacks.should_receive(:broadcast_creations).with(Product, {})
			Broadcastic::Callbacks.should_receive(:broadcast_updates).with(Product, {})
			class Product < ActiveRecord::Base
				broadcast :creations, :updates
			end
		end

	end

	context "with options" do

		it "should pass the destination options to the ModelCallbaks" do
			Broadcastic::Callbacks.should_receive(:broadcast_changes).with(Product, {to: :vendors})
			class Product < ActiveRecord::Base
				broadcast :changes, to: :vendors
			end
		end

	end

end
