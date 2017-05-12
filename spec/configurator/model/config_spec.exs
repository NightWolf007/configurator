defmodule Configurator.Model.ConfigSpec do
  use ESpec, async: false

  alias Configurator.Model.Config

  before do
    Application.put_env(:configurator, :namespace, "test_configurator")
  end

  finally do
    "test_configurator*"
    |> Exredis.Api.keys()
    |> Enum.map(&Exredis.Api.del(&1))
  end

  describe "find/1" do
    let :service, do: "service"
    let :data1, do: %{"x" => 1, "b" => "test1"}
    let :data2, do: %{"x" => 2, "b" => "test2"}
    let :data3, do: %{"x" => 3, "b" => "test3"}
    let :config1, do: %Config{name: "name1", service: service(), data: data1()}
    let :config2, do: %Config{name: "name2", service: service(), data: data2()}
    let :config3, do: %Config{name: "name3", service: service(), data: data3()}

    before do
      Config.save(config1())
      Config.save(config2())
      Config.save(config3())
    end

    it "returns list of configs" do
      result = described_module().find(service())
      expect result |> to(have_count 3)
      expect result |> to(have config1())
      expect result |> to(have config2())
      expect result |> to(have config3())
    end
  end

  describe "find/2" do
    let :name, do: "name"
    let :service, do: "service"
    let :data, do: %{"x" => 1, "b" => "test1"}
    let :config, do: %Config{name: name(), service: service(), data: data()}

    context "when key exists" do
      before do: Config.save(config())

      it "returns config" do
        expect described_module().find(service(), name())
        |> to(eq {:ok, config()})
      end
    end

    context "when key doesn't exists" do
      it "returns error" do
        expect described_module().find(service(), name())
        |> to(eq :error)
      end
    end
  end

  describe "save/1" do
    let :name, do: "name"
    let :service, do: "service"
    let :data, do: %{"x" => 1, "b" => "test1"}
    let :config, do: %Config{name: name(), service: service(), data: data()}

    it "saves config" do
      expect described_module().save(config()) |> to(eq :ok)
      expect described_module().find(service(), name())
      |> to(eq {:ok, config()})
    end
  end

  describe "delete/1" do
    let :name, do: "name"
    let :service, do: "service"
    let :data, do: %{"x" => 1, "b" => "test1"}
    let :config, do: %Config{name: name(), service: service(), data: data()}

    context "when key exists" do
      before do: Config.save(config())

      it "removes config" do
        expect described_module().delete(config()) |> to(eq :ok)
        expect described_module().find(service(), name()) |> to(eq :error)
      end
    end

    context "when key doesn't exists" do
      it "returns error" do
        expect described_module().delete(config()) |> to(eq :error)
      end
    end
  end

  describe "delete/2" do
    let :name, do: "name"
    let :service, do: "service"
    let :data, do: %{"x" => 1, "b" => "test1"}
    let :config, do: %Config{name: name(), service: service(), data: data()}

    context "when key exists" do
      before do: Config.save(config())

      it "removes config" do
        expect described_module().delete(service(), name()) |> to(eq :ok)
        expect described_module().find(service(), name()) |> to(eq :error)
      end
    end

    context "when key doesn't exists" do
      it "returns error" do
        expect described_module().delete(service(), name()) |> to(eq :error)
      end
    end
  end
end
