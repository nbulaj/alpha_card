# Object class needed to implement some nice
# active_support features for projects, that
# doesn't need active_support.
#
# Use-case: standalone Ruby scripts
class Object
  def blank?
    respond_to?(:empty?) ? !!empty? : !self
  end

  def present?
    !blank?
  end

  def try(*a, &b)
    if a.empty? && block_given?
      yield self
    else
      public_send(*a, &b) if respond_to?(a.first)
    end
  end
end
