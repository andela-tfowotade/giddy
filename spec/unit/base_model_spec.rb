require "spec_helper"
require 'pry'

RSpec.describe "GiddyRecord" do
  describe "#save" do
    after(:all) do
      Todo.destroy_all
    end

    context "when creating todo" do
      it "returns newly created todo" do
        todo = Todo.new attributes_for(:todo)
        todo.save
        expect(Todo.last.title).to eq todo.title
        Todo.destroy_all
      end

      it "increases the count of todos" do
        todo = Todo.new attributes_for(:todo)
        expect do
          todo.save
        end.to change { Todo.all.count }.by 1
        Todo.destroy_all
      end
    end
  end

  describe "#update" do
    before(:all) do
      @todo = create(:todo)
    end

    after(:all) do
      Todo.destroy_all
    end

    context "when updating todo" do
      it "doesn't create a new record in the database" do
        expect do
          @todo.update(body: "Watch the machester derby")
        end.to change { Todo.all.count }.by 0
      end

      it "updates the object" do
        @todo.update(title: "Watch el classico")
        expect(Todo.find(@todo.id).title).to eq "Watch el classico"
      end
    end
  end

  describe "#destroy" do
    it "decrease the count of todos" do
      todo = create(:todo)
      expect do
        todo.destroy
      end.to change { Todo.all.count }.by(-1)
    end
    Todo.destroy_all
  end

  describe ".destroy" do
    it "decrease the count of todos" do
      todo = create(:todo)
      expect do
        Todo.destroy(todo.id)
      end.to change { Todo.all.count }.by(-1)
    end
    Todo.destroy_all
  end

  describe ".all" do
    context "when database is not empty" do
      before(:all) do
        create(:todo, title: "D1")
        create(:todo, title: "D2")
      end

      after(:all) do
        Todo.destroy_all
      end

      it "returns all todos in the database" do
        todos = Todo.all
        expect(todos[0].title).to eq "D1"
        expect(todos[1].title).to eq "D2"
      end

      it "returns total number of records in the database" do
        expect(Todo.all.count).to eq 2
      end
    end

    context "when database is empty" do
      it "returns an empty array" do
        todos = Todo.all
        expect(todos).to eq []
      end
    end
  end

  describe ".last" do
    context "when there are records in the database" do
      it "returns the last created todo" do
        todo = create(:todo)
        expect(Todo.last.title).to eq todo.title
        Todo.destroy_all
      end
    end

    context "when database is empty" do
      it "returns nil" do
        expect(Todo.last).to eq nil
      end
    end
  end

  describe ".first" do
    context "when there are record on the database" do
      it "return the first todo in the database" do
        todos = create_list(:todo, 3)
        expect(Todo.first.title).to eq todos[0].title
        Todo.destroy_all
      end
    end

    context "when the database is empty" do
      it "returns nil" do
        expect(Todo.first).to eq nil
      end
    end
  end

  describe ".create" do
    it "returns newly created record" do
      expect(Todo.create(attributes_for(:todo)).title).to eq(
        Todo.last.title
      )
      Todo.destroy_all
    end

    it "increase todos count" do
      expect do
        Todo.create(attributes_for(:todo))
      end.to change { Todo.all.count }.by 1
      Todo.destroy_all
    end
  end
end
