RSpec.describe ClipCalendar do
  require "clip_calendar/version"
  require 'clipboard'
  require 'clip_calendar/core'

  it "has a version number" do
    expect(ClipCalendar::VERSION).not_to be nil
  end

  shared_examples "入力に対して期待通りの文字列を返すこと" do |in_array, expected_out|
    it (in_array.to_s+'の場合') {
      ARGV.clear
      ARGV.concat(in_array)
      clip_calendar= ClipCalendar::Core.new
      expect(clip_calendar.output).to eq expected_out
    }
  end

  shared_examples "例外を発生させること" do |in_array, exception|
    it (in_array.to_s+'の場合') {
      ARGV.clear
      ARGV.concat(in_array)
      expect{ clip_calendar= ClipCalendar::Core.new; clip_calendar.output }.to raise_error exception
    }
  end

  describe "課題２−１：既存の実行コードのテストを書く" do
    describe "正常に動くケース" do
      context "例に上げているケース" do
        it_behaves_like "入力に対して期待通りの文字列を返すこと", ['2020-05-18', '2020-05-22'], "2020/05/18(月)\n2020/05/19(火)\n2020/05/20(水)\n2020/05/21(木)\n2020/05/22(金)"
      end
      context "月またぎ（3日）" do
        it_behaves_like "入力に対して期待通りの文字列を返すこと", ['2016-02-28','2016-03-01'], "2016/02/28(日)\n2016/02/29(月)\n2016/03/01(火)"
      end
      context "年またぎ（10日）" do
        it_behaves_like "入力に対して期待通りの文字列を返すこと", ['1999-12-28','2000-01-06'], "1999/12/28(火)\n1999/12/29(水)\n1999/12/30(木)\n1999/12/31(金)\n2000/01/01(土)\n2000/01/02(日)\n2000/01/03(月)\n2000/01/04(火)\n2000/01/05(水)\n2000/01/06(木)"
      end
      context "一日しかない" do
        it_behaves_like "入力に対して期待通りの文字列を返すこと", ['2022-06-30','2022-06-30'], "2022/06/30(木)"
      end
      context "終了日が開始日より早い" do
        it_behaves_like "入力に対して期待通りの文字列を返すこと", ['2002-04-23','2000-01-15'], ""
      end
    end
    describe "エラーになるケース" do
      context "引数の数" do
        context "-fがないのに,引数が３つ" do
          it_behaves_like "例外を発生させること", ['2000-01-15','2002-04-23','2020-07-31'], ClipCalendar::ArgumentNumberError
        end
        context "引数が５つ" do
          it_behaves_like "例外を発生させること", ['2000-01-15','2002-04-23','2020-07-31','2020-8-6','2020-09-24'], ClipCalendar::ArgumentNumberError
        end
      end
      context "引数の型" do
        context "全角文字" do
          it_behaves_like "例外を発生させること", ['1984-04-30','全角文字'], ClipCalendar::ArgumentTypeError
        end
        context "yyyy年mm月dd日" do
          it_behaves_like "例外を発生させること", ['2022-06-30','2022年08月01日'], ClipCalendar::ArgumentTypeError
        end
        context "2020-02-30" do
          it_behaves_like "例外を発生させること", ['2020-02-27','2020ｰ2ｰ30'], ClipCalendar::ArgumentTypeError
        end
      end
    end
  end

  let(:thisyear) { Date.today.year }
  let(:dw) { ["日", "月", "火", "水", "木", "金", "土"] }
  shared_examples "入力に対して期待通りの文字列を返すこと(今年)" do
    it {
      ARGV.clear
      ARGV.concat(in_array)
      clip_calendar= ClipCalendar::Core.new
      expect(clip_calendar.output).to eq expected_out
    }
  end

  describe "課題２−２：年の省略" do

    context "開始日も終了日も年がない" do
      let(:in_array) { ['03-05','03-07'] }
      let(:expected_out) {
        (Date.new(thisyear,3,5)..Date.new(thisyear,3,7)).map {|d| d.strftime("%Y/%m/%d(#{dw[d.wday]})") }.join("\n")
      }
      it_behaves_like "入力に対して期待通りの文字列を返すこと(今年)"
    end
    context "開始日だけ年がない" do
      let(:in_array) { ['08-30',thisyear.to_s+'-09-03'] }
      let(:expected_out) {
        (Date.new(thisyear,8,30)..Date.new(thisyear,9,3)).map {|d| d.strftime("%Y/%m/%d(#{dw[d.wday]})") }.join("\n")
      }
      it_behaves_like "入力に対して期待通りの文字列を返すこと(今年)"
    end
    context "終了日だけ年がない" do
      let(:in_array) { [thisyear.to_s+'-01-18','01-25'] }
      let(:expected_out) {
        (Date.new(thisyear,1,18)..Date.new(thisyear,1,25)).map {|d| d.strftime("%Y/%m/%d(#{dw[d.wday]})") }.join("\n")
      }
      it_behaves_like "入力に対して期待通りの文字列を返すこと(今年)"
    end
  end

  describe "課題２−３：終了日の省略" do
    context "終了日がない" do
      it_behaves_like "入力に対して期待通りの文字列を返すこと", ['1999-12-28'], "1999/12/28(火)\n1999/12/29(水)\n1999/12/30(木)\n1999/12/31(金)\n2000/01/01(土)\n2000/01/02(日)"
    end
    context "終了日がない、開始日の年省略" do
      let(:in_array) { ['01-25'] }
      let(:expected_out) {
        (Date.new(thisyear,1,25)..Date.new(thisyear,1,30)).map {|d| d.strftime("%Y/%m/%d(#{dw[d.wday]})") }.join("\n")
      }
      it_behaves_like "入力に対して期待通りの文字列を返すこと(今年)"

    end
  end

  describe "課題２−４：日付の省略" do
    context "引数がない" do
      let(:in_array) { [] }
      let(:expected_out) {
        (Date.today..Date.today+5).map {|d| d.strftime("%Y/%m/%d(#{dw[d.wday]})") }.join("\n")
      }
      it_behaves_like "入力に対して期待通りの文字列を返すこと(今年)"
    end
  end

  describe "課題２−５：オプションで出力フォーマットを指定" do
    describe "正常ケース" do
      context "-f MM月dd日" do
        it_behaves_like "入力に対して期待通りの文字列を返すこと", ['-f',"MM月dd日",'1989-04-03','1989-04-06'], "04月03日\n04月04日\n04月05日\n04月06日"
      end
      context "-f %b. %d, %y" do
        it_behaves_like "入力に対して期待通りの文字列を返すこと", ['-f',"%b.%d,%y",'2020-09-29','2020-10-02'], "Sep.29,20\nSep.30,20\nOct.01,20\nOct.02,20"
      end
      context "-f あいうえお" do
        it_behaves_like "入力に対して期待通りの文字列を返すこと", ['-f',"あいうえお",'2000-01-01','2000-01-05'], "あいうえお\nあいうえお\nあいうえお\nあいうえお\nあいうえお"
      end
      context "出力オプション＋年省略" do
        it_behaves_like "入力に対して期待通りの文字列を返すこと", ['-f',"MM月dd日",'08-11','08-14'], "08月11日\n08月12日\n08月13日\n08月14日"
        it_behaves_like "入力に対して期待通りの文字列を返すこと", ['-f',"MM月dd日",'12-31','01-01'], ""
      end
      context "出力オプション＋終了日省略" do
        it_behaves_like "入力に対して期待通りの文字列を返すこと", ['-f',"%b.%-d,%y",'2023-11-09'], "Nov.9,23\nNov.10,23\nNov.11,23\nNov.12,23\nNov.13,23\nNov.14,23"
      end
      context "出力オプション＋日付省略" do
        let(:in_array) { ['-f', "%x"] }
        let(:expected_out) {
          (Date.today..Date.today+5).map {|d| d.strftime("%m/%d/%y") }.join("\n")
        }
        it_behaves_like "入力に対して期待通りの文字列を返すこと(今年)"
      end
    end
    describe "異常ケース" do
      context "-fのみは、ArgumentNumberError" do
        it_behaves_like "例外を発生させること", ['-f'], ClipCalendar::ArgumentNumberError
      end
    end
  end

end
