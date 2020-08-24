# 次の仕様を満たすモジュール SimpleMock を作成してください
#
# SimpleMockは、次の2つの方法でモックオブジェクトを作成できます
# 特に、2の方法では、他のオブジェクトにモック機能を付与します
# この時、もとのオブジェクトの能力が失われてはいけません
# また、これの方法で作成したオブジェクトを、以後モック化されたオブジェクトと呼びます
# 1.
# ```
# SimpleMock.new
# ```
#
# 2.
# ```
# obj = SomeClass.new
# SimpleMock.mock(obj)
# ```
#
# モック化したオブジェクトは、expectsメソッドに応答します
# expectsメソッドには2つの引数があり、それぞれ応答を期待するメソッド名と、そのメソッドを呼び出したときの戻り値です
# ```
# obj = SimpleMock.new
# obj.expects(:imitated_method, true)
# obj.imitated_method #=> true
# ```
# モック化したオブジェクトは、expectsの第一引数に渡した名前のメソッド呼び出しに反応するようになります
# そして、第2引数に渡したオブジェクトを返します
#
# モック化したオブジェクトは、watchメソッドとcalled_timesメソッドに応答します
# これらのメソッドは、それぞれ1つの引数を受け取ります
# watchメソッドに渡した名前のメソッドが呼び出されるたび、モック化したオブジェクトは内部でその回数を数えます
# そしてその回数は、called_timesメソッドに同じ名前の引数が渡された時、その時点での回数を参照することができます
# ```
# obj = SimpleMock.new
# obj.expects(:imitated_method, true)
# obj.watch(:imitated_method)
# obj.imitated_method #=> true
# obj.imitated_method #=> true
# obj.called_times(:imitated_method) #=> 2
# ```

module SimpleMock
  def self.mock(obj)
    obj.extend SimpleMock
    obj
  end

  def self.new
    mock(Object.new)
  end

  def expects(method, value)
    define_singleton_method(method) do
      @_method_call_log[method] += 1 if @_method_call_log&.key?(method)
      value
    end
    @mock_methods ||= []
    @mock_methods << method
  end

  def watch(method)
    @_method_call_log ||= {}
    @_method_call_log[method] ||= 0
    return if @mock_methods&.include?(method)

    singleton_class.class_eval do
      alias_method("old_#{method}", method)

      define_method(method) do
        @_method_call_log[method] += 1
        send("old_#{method}")
      end
    end
  end

  def called_times(method)
    @_method_call_log[method]
  end
end
