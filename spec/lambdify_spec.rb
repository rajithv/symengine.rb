describe 'SymEngine::lambdify_code' do
  
  let(:x) { SymEngine::Symbol.new('x') }
  let(:y) { SymEngine::Symbol.new('y') }
  let(:z) { SymEngine::Symbol.new('z') }
  
  def l(code)
    SymEngine::Utils::lambdify_code(code, [x])
  end
  
  it 'creates lambda codes' do
    expect(SymEngine::Utils::lambdify_code( x + y + z, [x, y, z])).to eq("proc { | x,y,z | x + y + z }")
    expect(l( x + 5 )).to eq("proc { | x | Rational(5,1) + x }")
    expect(l( SymEngine::sin(x) )).to eq("proc { | x | Math.sin(x) }")
    expect(l( SymEngine::cos(x) )).to eq("proc { | x | Math.cos(x) }")
    expect(l( SymEngine::tan(x) )).to eq("proc { | x | Math.tan(x) }")
    expect(l( SymEngine::asin(x) )).to eq("proc { | x | Math.asin(x) }")
    expect(l( SymEngine::acos(x) )).to eq("proc { | x | Math.acos(x) }")
    expect(l( SymEngine::atan(x) )).to eq("proc { | x | Math.atan(x) }")
    expect(l( SymEngine::sinh(x) )).to eq("proc { | x | Math.sinh(x) }")
    expect(l( SymEngine::cosh(x) )).to eq("proc { | x | Math.cosh(x) }")
    expect(l( SymEngine::tanh(x) )).to eq("proc { | x | Math.tanh(x) }")
    expect(l( SymEngine::asinh(x) )).to eq("proc { | x | Math.asinh(x) }")
    expect(l( SymEngine::acosh(x) )).to eq("proc { | x | Math.acosh(x) }")
    expect(l( SymEngine::atanh(x) )).to eq("proc { | x | Math.atanh(x) }")
    expect(l( SymEngine::gamma(x) )).to eq("proc { | x | Math.gamma(x) }")
    expect(l( x + SymEngine::PI )).to eq("proc { | x | x + Math::PI }")
    expect(l( x + SymEngine::E )).to eq("proc { | x | x + Math::E }")
    expect(l( x * SymEngine::I )).to eq("proc { | x | ::Complex::I*x }")
    expect(l( SymEngine::dirichlet_eta(x) )).to eq("proc { | x | SymEngine::Utils::evalf_dirichlet_eta(x) }")
    expect(l( SymEngine::zeta(x) )).to eq("proc { | x | SymEngine::Utils::evalf_zeta(x, Rational(1,1)) }")
    
    
  end
end

describe 'SymEngine::lambdify' do  

  let(:x) { SymEngine::Symbol.new('x') }
  let(:y) { SymEngine::Symbol.new('y') }
  let(:z) { SymEngine::Symbol.new('z') }
  
  describe 'lambda for Addition' do
    let(:func) { x + y + z }
    let(:lamb) { SymEngine::lambdify(func, x, y, z) }
    it 'performs addition with a lambda function' do
      expect(lamb.call(1, 1, 1)).to eq(3)
      expect(lamb.call(1, -1, 1)).to eq(1)
      expect(lamb.call(-1, -1, -1)).to eq(-3)
    end
  end
  
  describe 'lambda for Addition with FixNums' do
    let(:func) { x + 5}
    let(:lamb) { SymEngine::lambdify(func, [x]) }
    it 'performs addition with a lambda function' do
      expect(lamb.call(1)).to eq(6)
      expect(lamb.call(0)).to eq(5)
      expect(lamb.call(-1)).to eq(4)
      expect(lamb.call(Math::PI)).to be_within(1e-15).of(8.141592653589793)
    end
  end
  
  describe 'lambda for sin' do
    let(:func) { SymEngine::sin(x) }
    let(:lamb) { SymEngine::lambdify(func, [x]) }
    it 'performs sin calculation with a lambda function' do
      expect(lamb.call(0)).to be_within(1e-15).of(0.0)
      expect(lamb.call(Math::PI)).to be_within(1e-15).of(0.0)
      expect(lamb.call(Math::PI/2)).to be_within(1e-15).of(1.0)
    end
  end
  
  describe 'to_proc' do
    let(:func) { x * 10 }
    let(:func2) { x + y + 10}
    it 'creates procs' do
      expect([1, 2, 3, 4, 5].map(&func)).to eq([10, 20, 30, 40, 50])
      expect { [[1, 2], [3, 4]].map(&func2) }.to raise_error(ArgumentError)
      expect([[1, 2], [3, 4]].map(&func2.to_proc(x, y))).to eq([13, 17])
   end
  end
  
end
