require 'spec_helper'

describe 'AlphaCard objects deprecated methods' do
  def warn_writer(old_method, new_method)
    "[DEPRECATION] #{old_method}= is deprecated! Please, use #{new_method}= instead\n"
  end

  def warn_reader(old_method, new_method)
    "[DEPRECATION] #{old_method} is deprecated! Please, use #{new_method} instead\n"
  end

  it 'warns with deprecation message for AlphaCard::Sale' do
    AlphaCard::Sale::ORIGIN_TRANSACTION_VARIABLES.each do |new, old|
      expect { AlphaCard::Sale.new.send("#{old}=", 'T') }.to output(warn_writer(old, new)).to_stderr
      expect { AlphaCard::Sale.new.send(old) }.to output(warn_reader(old, new)).to_stderr
    end
  end

  it 'warns with deprecation message for AlphaCard::Billing' do
    AlphaCard::Billing::ORIGIN_TRANSACTION_VARIABLES.each do |new, old|
      expect { AlphaCard::Billing.new.send("#{old}=", 'T') }.to output(warn_writer(old, new)).to_stderr
      expect { AlphaCard::Billing.new.send(old) }.to output(warn_reader(old, new)).to_stderr
    end
  end

  it 'warns with deprecation message for AlphaCard::Shipping' do
    AlphaCard::Shipping::ORIGIN_TRANSACTION_VARIABLES.each do |new, old|
      expect { AlphaCard::Shipping.new.send("#{old}=", 'T') }.to output(warn_writer(old, new)).to_stderr
      expect { AlphaCard::Shipping.new.send(old) }.to output(warn_reader(old, new)).to_stderr
    end
  end
end
