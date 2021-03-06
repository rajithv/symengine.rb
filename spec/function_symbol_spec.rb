describe SymEngine::FunctionSymbol do

  let(:x) { sym('x') }
  let(:y) { sym('y') }
  let(:z) { sym('z') }

  describe '.new' do
    context 'with symbols' do
      subject { SymEngine::FunctionSymbol.new('f', x, y, z) }
      it { is_expected.to be_a SymEngine::FunctionSymbol }
    end

    context 'with compound arguments' do
      subject { SymEngine::FunctionSymbol.new('f', 2*x, y, SymEngine::sin(z)) }
      it { is_expected.to be_a SymEngine::FunctionSymbol }
    end
  end
  
  context '#diff' do
    let(:fun) { (SymEngine::FunctionSymbol.new('f', 2*x, y, SymEngine::sin(z))) }
    context 'by variable' do
      subject { fun.diff(x)/2 }
      it { is_expected.to be_a SymEngine::Subs }
    end
  end
  
  context 'Initializing with UndefFunctions' do
    let(:fun) { SymEngine::Function('f') }
    context 'UndefFunction' do
      subject { fun }
      it { is_expected.to be_a SymEngine::UndefFunction }
    end   
    context 'using call method for UndefFunction' do
      subject { fun.(x, y, z) }
      it { is_expected.to be_a SymEngine::FunctionSymbol }
    end
  end
end


