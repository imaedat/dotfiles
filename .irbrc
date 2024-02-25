def k; return 1024.0; end
def m; return k*k;    end
def g; return m*k;    end

class Array
  def sum
    return self.inject(0) {|_a,_e| _a+_e}
  end
  def ave
    return self.sum.quo(self.length)
  end
end

class Integer
  def bin(n=32)
    s = self.to_s(2)
    return "0"*(n-s.length) + s
  end
  def bin_f
    return self.bin.split(//).each_slice(4).map{|s| s.join}.join("_")
  end
  def hex(n=8)
    s = self.to_s(16)
    return "0"*(n-s.length) + s
  end
  def signed(bits=32)
    shift = bits - 1
    sign = self >> shift
    num = self & ~(1<<shift)
    return sign.zero? ? num : self-(1<<bits)
  end
end

# vi: set sw=2 ts=2 et:
