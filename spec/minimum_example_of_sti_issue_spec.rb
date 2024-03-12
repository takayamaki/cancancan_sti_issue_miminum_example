# frozen_string_literal: true

require 'rails_helper'

describe CanCan::Ability do
  before(:each) do
    (@ability = double).extend(CanCan::Ability)
  end

  describe 'about case of permit to read for one of subclasses' do
    before(:each) do
      @base_class_record = BaseClass.create!
      @sub_class_a_record = SubClassA.create!
      @sub_class_b_record = SubClassB.create!
    end

    it 'can reads BaseClass via BaseClass#accessible_by' do
      @ability.can :read, BaseClass

      expect(BaseClass.accessible_by(@ability).all).to include(@base_class_record, @sub_class_a_record, @sub_class_b_record)
    end

    it 'can reads SubClassA via BaseClass#accessible_by' do
      @ability.can :read, SubClassA

      aggregate_failures do
        expect(BaseClass.accessible_by(@ability).all).to include(@sub_class_a_record)
        expect(BaseClass.accessible_by(@ability).all).not_to include(@base_class_record, @sub_class_b_record)
      end
    end

    it 'can reads SubClassB via BaseClass#accessible_by' do
      @ability.can :read, SubClassB

      
      aggregate_failures do
        expect(BaseClass.accessible_by(@ability).all).to include(@sub_class_b_record)
        expect(BaseClass.accessible_by(@ability).all).not_to include(@base_class_record, @sub_class_a_record)
      end
    end
  end

  describe 'about case of permit to read for both of subclasses' do
    before(:each) do
      @base_class_record = BaseClass.create!
      @sub_class_a_record = SubClassA.create!
      @sub_class_b_record = SubClassB.create!
    end
    
    it 'can reads all of records via BaseClass#accessible_by' do
      @ability.can :read, BaseClass

      expect(BaseClass.accessible_by(@ability).all).to include(@base_class_record, @sub_class_a_record, @sub_class_b_record)
    end

    context 'permit by SubClass' do
      it 'can reads all of records via BaseClass#accessible_by when permit to read SubClassA before SubClassB' do
        @ability.can :read, SubClassA
        @ability.can :read, SubClassB

        aggregate_failures do
          expect(BaseClass.accessible_by(@ability).all).to include(@sub_class_a_record, @sub_class_b_record)
          expect(BaseClass.accessible_by(@ability).all).not_to include(@base_class_record)
        end
      end

      it 'can reads all of records via BaseClass#accessible_by when permit to read SubClassA after SubClassB' do
        @ability.can :read, SubClassB
        @ability.can :read, SubClassA

        aggregate_failures do
          expect(BaseClass.accessible_by(@ability).all).to include(@sub_class_a_record, @sub_class_b_record)
          expect(BaseClass.accessible_by(@ability).all).not_to include(@base_class_record)
        end
      end
    end
    
    context 'permit by BaseClass with condition' do
      it 'can reads all of records via BaseClass#accessible_by when permit to read SubClassA before SubClassB' do
        @ability.can :read, BaseClass, type: 'SubClassA'
        @ability.can :read, BaseClass, type: 'SubClassB'

        aggregate_failures do
          expect(BaseClass.accessible_by(@ability).all).to include(@sub_class_a_record, @sub_class_b_record)
          expect(BaseClass.accessible_by(@ability).all).not_to include(@base_class_record)
        end
      end

      it 'can reads all of records via BaseClass#accessible_by when permit to read SubClassA after SubClassB' do
        @ability.can :read, BaseClass, type: 'SubClassB'
        @ability.can :read, BaseClass, type: 'SubClassA'

        aggregate_failures do
          expect(BaseClass.accessible_by(@ability).all).to include(@sub_class_a_record, @sub_class_b_record)
          expect(BaseClass.accessible_by(@ability).all).not_to include(@base_class_record)
        end
      end
    end

    context 'permit by BaseClass with condition' do
      it 'can reads all of records via BaseClass#accessible_by when permit to read SubClassA before SubClassB' do
        @ability.can :read, BaseClass, type: SubClassA
        @ability.can :read, BaseClass, type: SubClassB

        aggregate_failures do
          expect(BaseClass.accessible_by(@ability).all).to include(@sub_class_a_record, @sub_class_b_record)
          expect(BaseClass.accessible_by(@ability).all).not_to include(@base_class_record)
        end
      end

      it 'can reads all of records via BaseClass#accessible_by when permit to read SubClassA after SubClassB' do
        @ability.can :read, BaseClass, type: SubClassB
        @ability.can :read, BaseClass, type: SubClassA

        aggregate_failures do
          expect(BaseClass.accessible_by(@ability).all).to include(@sub_class_a_record, @sub_class_b_record)
          expect(BaseClass.accessible_by(@ability).all).not_to include(@base_class_record)
        end
      end
    end
  end
end
