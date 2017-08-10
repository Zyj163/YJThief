module Fastlane
  module Actions
    module SharedValues
      WRITE_TAG_CUSTOM_VALUE = :WRITE_TAG_CUSTOM_VALUE
    end

    class WriteTagAction < Action
#真正执行的逻辑
      def self.run(params)
		#取出传递的参数
		tag = params[:tag]
		rl = params[:rl]
		
		File.open(rl,'r+'){|f|
		str=""
		f.each_line{|l|
		ss=l.gsub!(/[\s?]s.version[\s?]=[\s?]{1}/,"#")
		if ss
		str+="s.version = " + tag
		end
		}
		f.write str
		}
		
      end
#描述
      def self.description
        "write tag"
      end
  
#详细描述
      def self.details
        "修改podspecs中version"
      end

#参数
      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :tag,
                                       description: "tag name",
									   is_string: true,
									   optional: false
									   ),
          FastlaneCore::ConfigItem.new(key: :rl,
                                       description: "podspecs文件路径",
									   optional: false,
                                       is_string: true)
        ]
      end
#输出
      def self.output
        ""
      end
#返回值
      def self.return_value
		nil
      end
#作者
      def self.authors
        ["Zyj163"]
      end
#支持的平台
      def self.is_supported?(platform)
        [:ios, :mac].include? platform
      end
    end
  end
end
