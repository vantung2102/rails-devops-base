# frozen_string_literal: true

module HomeHelper
  # Dữ liệu từng slide: key đặt tên theo nghĩa nghiệp vụ để đọc code / doc dễ hiểu.
  # Xem docs/aws-devops-slides-content.md để tra cứu ý nghĩa từng trường, tổng quan kiến trúc và bản copy đầy đủ.
  def aws_sliders
    [
      {
        slide_id: 'iam',
        badge_label: 'IAM',
        official_name: 'AWS IAM',
        friendly_title: 'Kiểm soát ai được làm gì — trên từng tài nguyên cụ thể',
        benefit_headline: 'Thu hẹp phạm vi thiệt hại khi credential lộ hoặc quyền cấp sai, đồng thời chuẩn hóa phân quyền.',
        context_line: 'Áp dụng khi từ hai người hoặc hai dịch vụ trở lên cùng truy cập tài nguyên AWS; audit API khi đã bật CloudTrail và bảo vệ log theo chính sách.',
        screen_reader_label: 'Slide — Quản lý danh tính và phân quyền (IAM)',
        teaching_points_html: [
          '<strong>User</strong>, <strong>Group</strong>, <strong>Role</strong>, <strong>Policy</strong> là bốn lớp khác nhau — tránh gộp vai trò khi thiết kế quyền.',
          'Về kỹ thuật, <strong>Policy</strong> là tài liệu quyền gắn vào principal (user/group/role), không phải “tài khoản” đăng nhập — tách bạch giúp audit dễ hơn.',
          'Ưu tiên <strong>IAM Role</strong> cho EC2, Lambda và CI/CD; tránh access key tĩnh trong mã nguồn hoặc biến môi trường dùng chung.',
          'Nguyên tắc <em>least privilege</em>; có thể dùng <strong>IAM Access Analyzer</strong> để phát hiện quyền thừa hoặc truy cập cross-account.'
        ],
        value_for_operations: [
          'Quyền hẹp giúp giảm thiệt hại khi một credential bị lộ — “blast radius” nhỏ hơn.',
          'Onboarding và offboarding nhanh hơn nhờ nhóm và role chuẩn hóa theo vai trò.',
          'Nhật ký API qua CloudTrail (khi đã cấu hình trail và quyền xem log): biết thao tác và thời điểm — hỗ trợ audit và điều tra sự cố.',
          'CI/CD có thể dùng <strong>OIDC</strong> (GitHub Actions, GitLab, v.v.) để cấp credential ngắn hạn thay cho khóa dài hạn trên runner.'
        ],
        project_story_examples_html: [
          'Pipeline CI/CD dùng <strong>role</strong> với policy cho phép ghi vào prefix <code>releases/</code> (ví dụ <code>PutObject</code>; object lớn thường cần thêm quyền multipart) — không ghi được sang prefix khác.',
          'Thành viên mới vào <strong>Group</strong> chỉ đọc staging; khi off-board chỉ gỡ khỏi nhóm, không phải rà từng policy lẻ.',
          'Định kỳ rà policy bằng Access Analyzer trước kỳ kiểm toán — giảm bất ngờ về quyền public hoặc cross-account.',
          'Tổ chức nhiều account: <strong>SCP</strong> đặt trần quyền ở cấp OU — bổ sung cho IAM từng account, tránh “lỗ hổng” cấp tổ chức.'
        ]
      },
      {
        slide_id: 'ec2',
        badge_label: 'EC2',
        official_name: 'Amazon EC2',
        friendly_title: 'Máy chủ ảo — tùy chỉnh và mở rộng theo tải',
        benefit_headline: 'Kiểm soát đầy đủ OS và runtime, scale theo traffic thay vì đầu tư phần cứng cố định trước.',
        context_line: 'Web server, worker nền, batch, bastion hoặc workload cần cài phần mềm đặc thù trên máy.',
        screen_reader_label: 'Slide — Máy chủ ảo Amazon EC2',
        teaching_points_html: [
          'Chọn <strong>instance type</strong> theo bottleneck: ví dụ <code>c</code> khi CPU-bound, <code>r</code> khi cần RAM; <code>m</code> cho cân bằng; <code>t</code> burstable cần theo dõi credit — tránh “chọn dư” vì chi phí tăng theo size.',
          'Chính sách scale (target tracking, step scaling) nên ưu tiên tín hiệu gần người dùng khi có thể: độ trễ ALB, độ sâu hàng đợi — CPU chỉ là một trong các proxy.',
          'Dùng <strong>AMI</strong> chuẩn hóa để mọi môi trường khởi đầu giống nhau — tái lập bug và so sánh staging/production dễ hơn.',
          '<strong>Security Group</strong> là stateful firewall tầng instance: chỉ mở port và CIDR cần thiết; tránh mở SSH/RDP cho <code>0.0.0.0/0</code> trên production.'
        ],
        value_for_operations: [
          'Auto Scaling Group kết hợp ALB giúp hấp thụ đỉnh traffic mà không phải can thiệp tay từng lần.',
          'Tách instance theo vai trò (web, worker, bastion) để cô lập sự cố và tối ưu chi phí từng nhóm.',
          'AMI đồng nhất giảm tình trạng “chạy được trên staging nhưng lỗi trên production” do lệch môi trường.',
          'Giám sát CloudWatch (CPU, credit burstable, status check) giúp phát hiện sớm khi rule scale không còn khớp pattern tải thực tế.'
        ],
        project_story_examples_html: [
          'Ví dụ cấu hình: ASG scale-out khi CPU &gt; 70% trong vài phút — chỉ minh họa; rule thật nên tune theo latency, queue hoặc tín hiệu ALB.',
          'Cùng một AMI và userdata cho cả staging và production — lỗi cấu hình lộ sớm trước khi lên prod.',
          'Chỉ bastion host mở SSH từ IP nội bộ; máy web không có inbound SSH từ Internet.',
          'Kết hợp <strong>Systems Manager Session Manager</strong> để truy cập máy không mở SSH public — giảm bề mặt tấn công (tùy chính sách mạng).'
        ]
      },
      {
        slide_id: 's3',
        badge_label: 'S3',
        official_name: 'Amazon S3',
        friendly_title: 'Kho object bền — file, static asset và artifact ở quy mô lớn',
        benefit_headline: 'Giảm tải I/O cho máy ứng dụng và tách lifecycle, chi phí theo từng loại dữ liệu.',
        context_line: 'Static asset, upload người dùng, artifact triển khai và backup định kỳ; có thể thêm Object Lock khi cần immutability.',
        screen_reader_label: 'Slide — Lưu trữ đối tượng Amazon S3',
        teaching_points_html: [
          'S3 dùng <strong>bucket</strong> và <strong>prefix</strong> (không phải cây thư mục thật) — thiết kế prefix hợp lý giúp phân quyền theo path và giảm chi phí thao tác liệt kê không cần thiết.',
          'Bật <strong>versioning</strong> để chống ghi đè và xóa nhầm; với log audit hoặc compliance có thể cân nhắc <strong>Object Lock</strong>.',
          '<strong>Object Lock</strong> bắt buộc có versioning; chọn governance vs compliance theo yêu cầu pháp lý — cân nhắc kỹ trước khi bật trên bucket đa mục đích.',
          '<strong>Lifecycle</strong> chuyển object sang tầng rẻ hơn (ví dụ S3-IA, Glacier) sau N ngày — giảm cost lưu trữ dài hạn.'
        ],
        value_for_operations: [
          'Upload lớn qua presigned URL thẳng lên S3 — app server không phải nhận toàn bộ luồng file.',
          'Bucket riêng cho staging và production — tránh lẫn dữ liệu và sai cấu hình endpoint giữa môi trường.',
          'Versioning cho phép khôi phục file cấu hình hoặc artifact bị ghi đè sai trong thời gian ngắn.',
          '<strong>Replication</strong> (cùng hoặc khác region) hỗ trợ DR và bản sao theo yêu cầu — tính chi phí và độ trễ consistency theo tài liệu S3.'
        ],
        project_story_examples_html: [
          'Release lỗi ghi đè <code>config/settings.json</code> trên S3; restore bản trước nhờ versioning, không cần deploy lại toàn bộ.',
          'Artifact CI/CD vào <code>s3://artifacts-prod/builds/{git-sha}/</code> — truy vết theo commit.',
          'Lifecycle đưa log cũ sang tầng rẻ sau 90 ngày — giảm bill mà vẫn giữ dữ liệu cho điều tra.',
          'Bucket nhận upload public: kết hợp <strong>CloudFront</strong> + OAC/OAI và policy bucket chặn truy cập trực tiếp không mong muốn.'
        ]
      },
      {
        slide_id: 'dns',
        badge_label: 'DNS',
        official_name: 'Amazon Route 53',
        friendly_title: 'Tên miền và điều hướng traffic tập trung',
        benefit_headline: 'DNS tập trung giúp migration và phản ứng sự cố nhanh hơn, bớt phụ thuộc nhiều nhà cung cấp rời rạc.',
        context_line: 'Hosted zone, health check endpoint, weighted hoặc failover routing; chi tiết giá bản ghi và query xem bảng giá AWS.',
        screen_reader_label: 'Slide — DNS và định tuyến Route 53',
        teaching_points_html: [
          '<strong>Hosted zone</strong> gom <em>bản ghi DNS</em> của domain (có thể tách với nơi <strong>đăng ký</strong> tên miền ở registrar) — quản lý record tập trung trên AWS.',
          'Bản ghi kiểu <strong>Alias</strong> trỏ tới ALB, CloudFront hoặc tài nguyên AWS thường phù hợp <em>zone apex</em> hơn CNAME thuần; chi phí theo loại bản ghi và lượt query — tham khảo tài liệu giá Route 53.',
          '<strong>Health check</strong> và routing failover giúp chuyển traffic sang endpoint dự phòng khi primary lỗi — giảm MTTR khi đã cấu hình sẵn.',
          '<strong>Private hosted zone</strong> gắn VPC phục vụ tên nội bộ; kết hợp Resolver hoặc hybrid DNS khi cần nối on-prem và cloud.'
        ],
        value_for_operations: [
          'Trước cutover migration: hạ TTL (ví dụ 60 giây) một thời gian, sau khi ổn định tăng lại — kiểm soát propagation.',
          'Một nơi quản lý DNS giúp audit và tránh xung đột bản ghi giữa các hệ thống.',
          'Weighted routing hỗ trợ canary hoặc chia tỷ lệ traffic khi cần thử nghiệm an toàn.',
          'Health check Route 53 là dịch vụ có phí theo tài liệu — lên kế hoạch số lượng check và tần suất để tránh bill không chủ ý.'
        ],
        project_story_examples_html: [
          'Trước bảo trì: TTL 60s trong 24h; sau đổi Alias sang ALB mới; khi ổn định đặt TTL cao hơn để giảm query.',
          'Tên miền public trỏ Alias vào ALB — không lộ trực tiếp địa chỉ instance ra client.',
          'Failover record: primary unhealthy thì traffic sang endpoint dự phòng (cùng hoặc khác region, tùy thiết kế).',
          'API nội bộ dùng tên <code>api.internal.example</code> trong private zone — tách khỏi public hosted zone giảm rủi ro lộ surface.'
        ]
      },
      {
        slide_id: 'rds',
        badge_label: 'RDS',
        official_name: 'Amazon RDS (PostgreSQL)',
        friendly_title: 'PostgreSQL do AWS vận hành — tập trung dữ liệu và truy vấn',
        benefit_headline: 'Backup tự động, patch và chuyển đổi dự phòng do dịch vụ quản lý — team tập trung schema và hiệu năng query.',
        context_line: 'Workload OLTP production; cân nhắc Aurora PostgreSQL khi cần scale đọc hoặc mô hình serverless phù hợp.',
        screen_reader_label: 'Slide — Cơ sở dữ liệu quan hệ Amazon RDS',
        teaching_points_html: [
          'RDS gồm backup tự động, PITR trong cửa sổ giữ (theo loại engine và cấu hình), patch nhỏ và giám sát CloudWatch — nâng <strong>major version</strong> vẫn cần kế hoạch và thử nghiệm.',
          '<strong>Multi-AZ</strong> phục vụ sẵn sàng cao (standby đồng bộ ở AZ khác), không thay thế scale đọc; scale đọc dùng <strong>Read Replica</strong>.',
          'Một số engine hỗ trợ <strong>Blue/Green Deployment</strong> cho thay đổi lớn — khả dụng, bước và thời gian chuyển đổi phụ thuộc engine/region; xem tài liệu RDS trước khi cam kết downtime.',
          '<strong>Snapshot</strong> thủ công trước thay đổi lớn bổ sung cho automated backup — điểm rollback rõ ràng.'
        ],
        value_for_operations: [
          'PITR giúp khôi phục sau thao tác sai tới mức thời gian mà dịch vụ hỗ trợ — giảm mất dữ liệu logic.',
          'Parameter Group và Option Group theo dõi được trong quy trình — thay đổi cấu hình DB có vết audit.',
          'Read Replica cho báo cáo hoặc analytics giảm tải IOPS và CPU trên primary.',
          'Theo dõi <strong>ReplicaLag</strong> và Performance Insights giúp quyết định khi nào cần thêm replica hoặc tối ưu truy vấn thay vì chỉ nâng cấp primary.'
        ],
        project_story_examples_html: [
          'Trước nâng PostgreSQL major trên <strong>RDS</strong>: snapshot, nâng thử <strong>staging instance</strong> qua console/API (luồng upgrade do AWS quản lý), kiểm tra extension và app, rồi maintenance window prod kèm rollback — <code>pg_upgrade</code> là kiểu máy tự quản (EC2), không phải mô hình RDS.',
          'Sự cố sau migration: restore snapshot hoặc PITR tới thời điểm trước lỗi — playbook đã viết sẵn.',
          'Báo cáo nặng chạy trên replica; dashboard kinh doanh không làm chậm giao dịch OLTP trên primary.',
          'Parameter group thay đổi trên staging trước — so sánh <code>pg_stat_statements</code> hoặc slow query log trước khi áp production.'
        ]
      },
      {
        slide_id: 'eb',
        badge_label: 'Elastic Beanstalk',
        official_name: 'AWS Elastic Beanstalk',
        friendly_title: 'Triển khai ứng dụng nhanh — không lắp từng máy tay',
        benefit_headline: 'Rút ngắn đường từ merge tới production nhờ ALB, Auto Scaling và health check có sẵn.',
        context_line: 'Web app và API cần velocity; orchestration container phức tạp hơn thường xem ECS hoặc EKS.',
        screen_reader_label: 'Slide — Nền tảng triển khai Elastic Beanstalk',
        teaching_points_html: [
          'Ba khái niệm: <strong>Application</strong> (codebase) → <strong>Application Version</strong> (artifact) → <strong>Environment</strong> (tài nguyên đang chạy) — phân biệt khi debug.',
          'Phiên bản nền tảng (<strong>AL2</strong> vs <strong>AL2023</strong>) khác glibc, OpenSSL và vòng đời — migration cần thử native extension (gem, npm).',
          'Ưu tiên <code>.ebextensions</code> và <code>.platform</code> hooks thay vì SSH chỉnh tay — cấu hình nằm trong version control.',
          '<strong>CI/CD</strong> (CodePipeline, GitHub Actions, GitLab CI, v.v.) đóng gói artifact và deploy version lên Beanstalk — tự động hóa đường đi từ merge tới môi trường được kiểm soát.'
        ],
        value_for_operations: [
          'Blue/Green (swap URL môi trường) giảm downtime và cho phép rollback nhanh nếu bản mới lỗi.',
          'Saved Configuration giúp nhân bản môi trường mới nhất quán — giảm drift giữa các env.',
          'CloudWatch Logs tích hợp sẵn; <strong>X-Ray</strong> và trace liên dịch vụ cần <strong>bật và cấu hình</strong> (console hoặc <code>.ebextensions</code>) — không tự có đầy đủ trace nếu chưa bật.',
          'Elastic Beanstalk là <strong>PaaS trên EC2</strong> — không phải serverless; vẫn cần quan sát capacity, patch platform và chi phí instance theo thời gian chạy.'
        ],
        project_story_examples_html: [
          'Nâng AL2 → AL2023: tạo environment mới, smoke test, swap CNAME blue/green — lỗi thì swap lại trong thời gian ngắn.',
          'Cùng một Saved Configuration cho staging và production — chỉ khác biến môi trường và kích thước capacity.',
          'Deploy lỗi: quay lại bằng cách <strong>triển khai lại application version</strong> đã biết ổn (hoặc swap blue/green) thay vì sửa gấp trực tiếp trên prod.',
          'Biến môi trường và secret không đóng gói cố định trong WAR/zip: dùng console Beanstalk, SSM Parameter Store hoặc Secrets Manager tùy rotation.'
        ]
      },
      {
        slide_id: 'backup',
        badge_label: 'Sao lưu',
        official_name: 'Chiến lược sao lưu đa lớp',
        friendly_title: 'Bốn lớp: DB, object, cấu hình và secret',
        benefit_headline: 'Khi sự cố xảy ra, khôi phục theo playbook đã thử — không phụ thuộc trí nhớ cá nhân.',
        context_line: 'Mỗi lớp có RPO/RTO riêng; restore drill định kỳ — backup chưa từng restore thì rủi ro vẫn cao.',
        screen_reader_label: 'Slide — Chiến lược sao lưu nhiều lớp',
        teaching_points_html: [
          'Bốn lớp: <strong>database</strong> (RDS snapshot + PITR), <strong>S3</strong> (versioning, tùy chọn replication), <strong>cấu hình</strong> (export Beanstalk, Parameter Store), <strong>secret</strong> (Secrets Manager hoặc vault nội bộ) — không commit secret vào Git.',
          '<strong>Parameter Store SecureString</strong> phù hợp secret đơn giản; <strong>Secrets Manager</strong> thuận tiện hơn khi cần rotation tích hợp — chọn theo yêu cầu vận hành và audit.',
          'Định nghĩa <strong>RPO/RTO</strong> riêng từng lớp; tránh một chiến lược “vừa đủ” cho mọi loại dữ liệu.',
          'Lên lịch <strong>restore drill</strong>: chứng minh khôi phục được, không chỉ kiểm tra backup tồn tại.'
        ],
        value_for_operations: [
          'Giảm MTTR khi có điểm khôi phục rõ và người on-call biết bước tiếp theo.',
          'Hỗ trợ yêu cầu compliance và audit nhờ nhật ký backup/restore có timestamp.',
          'Giảm rủi ro “có file backup nhưng không restore được” do lỗi mã hóa, quyền hoặc phiên bản.',
          'Sao lưu <strong>IaC</strong> (Terraform state có khóa remote, CloudFormation template) — tránh chỉ có backup DB mà mất khả năng tái tạo hạ tầng nhất quán.'
        ],
        project_story_examples_html: [
          'Trước maintenance lớn: snapshot RDS + verify, xác nhận versioning bucket quan trọng, export Saved Configuration Beanstalk.',
          'Drill hàng quý: restore RDS sang VPC cô lập và chạy smoke query — ghi lại thời gian thực tế.',
          'Rotation secret trên Secrets Manager được giám sát; cảnh báo nếu job rotation fail.',
          'Export template CloudFormation hoặc commit Terraform cho ALB/RDS/S3 — phục hồi sau sự cố region nhanh hơn chỉ có bản dump SQL.'
        ]
      },
      {
        slide_id: 'lifecycle',
        badge_label: 'Ngừng vận hành',
        official_name: 'Quy trình tắt hệ thống an toàn',
        friendly_title: 'Sunset có thứ tự — không sót dữ liệu, không sót chi phí',
        benefit_headline: 'Đóng hệ thống theo checklist: tránh mất data, resource mồ côi vẫn tính phí và DNS trỏ nhầm.',
        context_line: 'Sau backup và xác nhận restore: dọn compute và data, thu hồi quyền, cập nhật DNS cuối cùng.',
        screen_reader_label: 'Slide — Quy trình ngừng vận hành hệ thống',
        teaching_points_html: [
          'Thứ tự gợi ý: <strong>backup + verify</strong> → dọn <strong>Beanstalk/EC2</strong> → <strong>RDS</strong> (final snapshot) → <strong>S3</strong> → <strong>thu hồi IAM</strong> → <strong>Route 53</strong> cuối cùng — sai thứ tự dễ sót NAT, EIP hoặc volume.',
          'Đây là <strong>khung checklist</strong> — điều chỉnh nếu cần drain traffic, giữ bản sao pháp lý, hoặc phụ thuộc giữa app và DB.',
          'Cập nhật <strong>DNS sau cùng</strong> để người dùng không trỏ vào endpoint đã tắt trong lúc còn dọn tài nguyên.',
          'Tag <code>Project</code> / <code>Env</code> từ đầu; khi decommission dùng Resource Groups hoặc <strong>AWS Config</strong> để rà soát tài nguyên còn sót.'
        ],
        value_for_operations: [
          'Final snapshot và archive S3 là lưới an toàn trước khi xóa dữ liệu production.',
          'Giảm chi phí âm thầm từ EBS, Elastic IP, NAT Gateway hoặc load balancer chưa gỡ hết.',
          'CloudTrail ghi nhận terminate và xóa khi trail đã bật — phục vụ audit và bàn giao.',
          'Sau 7–30 ngày: rà <strong>Cost Explorer</strong> theo tag dự án — bắt dịch vụ “lẻ” (S3 bucket rỗng, log group, interface endpoint).'
        ],
        project_story_examples_html: [
          'Sunset web: snapshot RDS + verify, archive bucket quan trọng, terminate Beanstalk (EC2, ALB, ASG), xóa RDS có final snapshot, revoke role, trỏ DNS về trang thông báo.',
          'Sau một tuần vẫn thấy bill NAT: quét theo tag project — phát hiện VPC và NAT chưa xóa.',
          'DNS trỏ tạm sang maintenance page trong lúc team xác nhận không còn client legacy.',
          'Tắt auto-renew chứng chỉ ACM hoặc xóa cert không dùng sau khi domain đã trỏ đi — tránh cảnh báo và nhầm lẫn vận hành.'
        ]
      },
      {
        slide_id: 'summary',
        badge_label: 'Tổng kết',
        official_name: 'Nguyên tắc vận hành DevOps trên AWS',
        friendly_title: 'Từ danh sách dịch vụ đến văn hóa vận hành chung',
        benefit_headline: 'Công cụ đúng, quy trình rõ và tài liệu cập nhật giúp giảm panic lúc sự cố và tăng tốc phối hợp.',
        context_line: 'Runbook, lịch on-call và văn hóa postmortem bổ sung cho công cụ — không thay thế nhau.',
        screen_reader_label: 'Slide — Tổng kết nguyên tắc vận hành',
        teaching_points_html: [
          'Triết lý <em>you build it, you run it</em>: team chịu trách nhiệm cả triển khai và vận hành — khuyến khích code dễ quan sát và rollback.',
          '<strong>Tự động hóa</strong> (build, test, deploy) và <strong>đo lường</strong> (SLI/SLO, dashboard, cảnh báo) biến DevOps thành vòng phản hồi có số liệu, không chỉ khẩu hiệu.',
          'Luôn <strong>backup</strong> trước thay đổi lớn và kiểm chứng trên môi trường gần production (cùng platform, instance type, dữ liệu ẩn danh khi cần).',
          '<strong>Runbook</strong> cho thao tác lặp; quyết định kiến trúc ghi <strong>ADR</strong> hoặc rút kinh nghiệm qua postmortem — giảm phụ thuộc cá nhân.'
        ],
        value_for_operations: [
          'Incident nhanh hơn khi on-call có checklist và cùng ngôn ngữ với tài liệu.',
          'Onboarding ngắn hơn nhờ sơ đồ kiến trúc và runbook cập nhật.',
          'Traceability: biết vì sao chọn thiết kế này và bài học sau mỗi sự cố.',
          'Pipeline đưa thay đổi qua <strong>staging</strong> với kiểm thử tự động — giảm “đường tắt” production và tăng niềm tin khi rollback.'
        ],
        project_story_examples_html: [
          'Kiến trúc tham chiếu demo: <strong>Route 53</strong> → <strong>ALB</strong> → <strong>Elastic Beanstalk</strong> → <code>EC2</code> (ASG), <strong>RDS PostgreSQL</strong> (Multi-AZ khi cần), <strong>S3</strong>; mỗi thành phần dùng <strong>IAM role</strong> tối thiểu.',
          'Sự cố deploy: runbook ghi bước swap URL, rollback version và kiểm tra health — on-call không phải tự nghĩ lại dưới áp lực.',
          'Sau incident: postmortem không đổ lỗi cá nhân — cập nhật runbook và giám sát để lỗi tương tự khó lặp lại.',
          'Mỗi dịch vụ trong phạm vi team có <strong>owner</strong>, dashboard tối thiểu (sức khỏe + saturation + error) và ít nhất một runbook happy path + một failure path.'
        ]
      }
    ]
  end

  def total_sliders
    1 + aws_sliders.size
  end
end
