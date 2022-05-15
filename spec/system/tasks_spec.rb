require 'rails_helper'

describe 'タスク管理機能', type: :system do

  shared_examples_for 'ユーザーAが作成したタスクが表示される' do
    it { expect(page).to have_content '最初のタスク'}
  end

  describe '一覧表示機能' do
    let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example') }
    let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example') }
    let(:task_a) { FactoryBot.create(:task, name: '最初のタスク', user: user_a) }

    before do
      # ユーザーAを作成しておく
      # 作成者がユーザーAであるタスクを作成しておく
      FactoryBot.create(:task, name: '最初のタスク', user: user_a)

      # ログインする
      visit login_path
      fill_in 'メールアドレス', with: login_user.email
      fill_in 'パスワード', with: login_user.password
      click_button 'ログインする'
    end

    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }

      it_behaves_like 'ユーザーAが作成したタスクが表示される'
    end

    context 'ユーザーBがログインしているとき' do
      let(:login_user) { user_a }

      it 'ユーザーBが作成したタスクが表示される' do
        # 作成済みのタスクの名称が画面上に表示されていることを確認
          expect(page).to have_content '最初のタスク'
        end
    end

    describe '詳細表示機能' do
      context 'ユーザーAがログインしているとき' do
        let(:login_user) { user_a }

        before do
          visit task_path(task_a)
        end

        it_behaves_like 'ユーザーAが作成したタスクが表示される'
      end
    end
  end
end
