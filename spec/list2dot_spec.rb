RSpec.describe 'list' do
  let(:list) do
    "1 1 4\n"\
    "1 2 5\n"\
    '2 3 6'
  end

  it 'generates output for a dot file' do
    graph = "graph {\n"\
            "1 -- 1;\n"\
            "1 -- 2;\n"\
            "2 -- 3;\n"\
            '}'

    expect(list2dot(list)).to eq(graph)
  end

  it 'returns nothing if list is nil' do
    expect(list2dot(nil)).to be nil
  end

  it 'returns nothing if list is empty' do
    expect(list2dot('')).to be nil
  end

  it 'returns directed graph' do
    directed_graph = "digraph {\n"\
            "1 -> 1;\n"\
            "1 -> 2;\n"\
            "2 -> 3;\n"\
            '}'

    options = { directed: true }

    expect(list2dot(list, options)).to eq(directed_graph)
  end

  it 'labels weights' do
    weighted_graph = "graph {\n"\
            "1 -- 1 [label=\"4\"];\n"\
            "1 -- 2 [label=\"5\"];\n"\
            "2 -- 3 [label=\"6\"];\n"\
            '}'

    options = { weights: true }
    expect(list2dot(list, options)).to eq(weighted_graph)
  end

  it 'directed weights' do
    directed_weighted_graph = "digraph {\n"\
            "1 -> 1 [label=\"4\"];\n"\
            "1 -> 2 [label=\"5\"];\n"\
            "2 -> 3 [label=\"6\"];\n"\
            '}'

    options = { weights: true, directed: true }
    expect(list2dot(list, options)).to eq(directed_weighted_graph)
  end

  it 'leading edge and node counts' do
    list = "4 5\n"\
           "1 2 3\n"\
           "2 3 4\n"\
           "1 4 5\n"\
           "2 4 6\n"\
           "3 4 7\n"

    graph = "graph {\n"\
            "1 -- 2;\n"\
            "2 -- 3;\n"\
            "1 -- 4;\n"\
            "2 -- 4;\n"\
            "3 -- 4;\n"\
            '}'

    options = { leading: true }
    expect(list2dot(list, options)).to eq(graph)
  end

  it 'reports nodes mismatch' do
    list = "6 5\n"\
           "1 2 3\n"\
           "2 3 4\n"\
           "1 4 5\n"\
           "2 4 6\n"\
           "3 4 7\n"

    options = { leading: true }
    expect { list2dot(list, options) }.to raise_error ArgumentError
  end

  it 'reports edge mismatch' do
    list = "4 5\n"\
           "1 2 3\n"\
           "2 3 4\n"\
           "1 4 5\n"\
           "3 4 7\n"

    options = { leading: true }
    expect { list2dot(list, options) }.to raise_error ArgumentError
  end
end
