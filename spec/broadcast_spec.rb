require 'spec_helper'

class Product < ActiveRecord::Base; end

describe Broadcastic::Broadcast do

	context "with a valid event" do
		it "Should undertstand the broadcast method and not raise an exception" do
			expect  {
				class Product < ActiveRecord::Base
					broadcast :changes
				end
			}.to_not raise_error(NoMethodError, /undefined method `broadcast'/)
		end
	end

	context "with an invalid event" do
		it "Should raise an exception" do
			expect  {
				class Product < ActiveRecord::Base
					broadcast :some_non_existing_callback
				end
			}.to raise_error(Broadcastic::InvalidCallbackName)
		end
	end

	context "with an invalid recipient" do

		it "Should raise an exception about the recipient method being invalid" do

			undefine_product_class

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

		  undefine_product_class

			expect  {
				class Product < ActiveRecord::Base
					broadcast :creations, to: :vendors

					def vendors
						["vendors/1", "vendors/2"]
					end
				end
				p = Product.create(name: "foo")
			}.to_not raise_error(NoMethodError, /undefined method `some_recipient'/)
		end
	end

	context "without options" do

		it "should send the appropriate message to Callbacks for each callback type" do
		  undefine_product_class
		  class Product < ActiveRecord::Base; end
			Broadcastic::Callbacks.should_receive(:broadcast_changes).with(Product, {})
			class Product < ActiveRecord::Base
				broadcast :changes
			end
		end

		it "should send the appropriate message to Callbacks for each callback type" do
		  undefine_product_class
		  class Product < ActiveRecord::Base; end
			Broadcastic::Callbacks.should_receive(:broadcast_creations).with(Product, {})
			Broadcastic::Callbacks.should_receive(:broadcast_updates).with(Product, {})
			class Product < ActiveRecord::Base
				broadcast :creations, :updates
			end
		end

	end

	context "with options" do

		it "should pass the destination options to the ModelCallbaks" do
		  undefine_product_class
		  class Product < ActiveRecord::Base; end
			Broadcastic::Callbacks.should_receive(:broadcast_changes).with(Product, {to: :vendors})
			class Product < ActiveRecord::Base
				broadcast :changes, to: :vendors
			end
		end

	end

end
