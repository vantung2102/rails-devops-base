# Nội dung slide: DevOps trên AWS (bản hợp nhất)

Tài liệu này mô tả **ý nghĩa từng trường dữ liệu**, **tổng quan kiến trúc** và **bản copy đầy đủ** dùng trên trang chủ (`HomeHelper#aws_sliders`). Mục tiêu: người kỹ thuật và **khách hàng / stakeholder không chuyên** đều nắm được cấu trúc và nội dung khi làm tài liệu đối ngoại hoặc onboarding.

Nội dung được hợp nhất từ hai hướng biên tập: **chi tiết, chính xác AWS** (bản dài) và **tối ưu đọc nhanh trên carousel** (bản rút gọn), với ràng buộc: tiếng Việt chủ đạo, phân biệt các cặp khái niệm dễ nhầm, không khẳng định tuyệt đối về giá dịch vụ (đặc biệt Route 53).

---

## Tổng quan: DevOps trên AWS trong demo này

Demo trình bày **chín slide** trong carousel (cộng một slide mở đầu ở intro), đi từ **danh tính và phân quyền** tới **nguyên tắc vận hành**. Thứ tự đọc gợi ý: **IAM** (ai được làm gì) → **EC2** (compute) → **S3** (object storage) → **Route 53** (DNS và routing) → **RDS PostgreSQL** (dữ liệu quan hệ) → **Elastic Beanstalk** (triển khai ứng dụng) → **sao lưu đa lớp** → **ngừng vận hành an toàn** → **tổng kết văn hóa DevOps**.

**Kiến trúc tham chiếu** của demo: người dùng tới **Route 53**, traffic vào **Application Load Balancer**, ứng dụng chạy trên **Elastic Beanstalk** (EC2 trong Auto Scaling Group), dữ liệu quan hệ trên **RDS**, file và artifact trên **S3**; **IAM role** gắn với từng thành phần theo nguyên tắc least privilege. Slide không thay thế tài liệu thiết kế chi tiết hay bảng giá AWS — mục đích là **bản đồ tinh thần** và **điểm neo kỹ thuật** cho cuộc trò chuyện với khách hàng hoặc thành viên mới trong team.

---

## Slide mở đầu (ngoài danh sách helper)

Slide đầu tiên nằm trong partial `app/views/home/_intro.html.slim`, không nằm trong mảng `aws_sliders`. Hàm `total_sliders` tính `1 + aws_sliders.size` vì lý do đó.

---

## Bảng giải thích tên field (key)

| Key trong code | Ý nghĩa (ngôn ngữ nghiệp vụ) |
|----------------|------------------------------|
| `slide_id` | Mã ngắn, ổn định — theme/CSS, analytics hoặc tracking (ví dụ `iam`, `s3`). |
| `badge_label` | Nhãn ngắn trên badge, thường là tên viết tắt dịch vụ. |
| `official_name` | Tên sản phẩm theo tài liệu AWS. |
| `friendly_title` | Tiêu đề dễ hiểu (tiếng Việt) — ngôn ngữ kinh doanh / tổng quan. |
| `benefit_headline` | Một câu giá trị cốt lõi: vì sao chủ đề này quan trọng. |
| `context_line` | Bối cảnh: khi nào áp dụng, phạm vi, trade-off (kể cả khi *không* nên dùng dịch vụ đó). |
| `screen_reader_label` | Nhãn ARIA cho trình đọc màn hình. |
| `teaching_points_html` | Khái niệm kỹ thuật; mảng chuỗi, mỗi phần tử một ý; cho phép HTML (`<strong>`, `<em>`, `<code>`). |
| `value_for_operations` | Lợi ích vận hành — **plain text**, không HTML (escape trên UI). |
| `project_story_examples_html` | Ví dụ / case; mảng chuỗi có HTML như trên. |

**Quy ước độ dài (carousel):** mỗi mảng `teaching_points_html`, `value_for_operations`, `project_story_examples_html` thường **3–5 mục** (không cố định 3) — ưu tiên đúng kỹ thuật và đủ ngữ cảnh demo; headline và `context_line` vẫn nên gọn để quét nhanh.

**Nguồn chuẩn:** `app/helpers/home_helper.rb` — khi chỉnh copy, cập nhật helper trước, sau đó đồng bộ mục tương ứng trong tài liệu này.

---

## Danh sách slide (copy đầy đủ)

Nội dung dưới đây **tóm tắt** khớp `app/helpers/home_helper.rb` (trong code có HTML trong các field `*_html`). Chi tiết đầy đủ và số bullet mới nhất xem trực tiếp helper.

### 1. IAM — `slide_id: iam`

| Field | Nội dung |
|--------|-----------|
| badge_label | IAM |
| official_name | AWS IAM |
| friendly_title | Kiểm soát ai được làm gì — trên từng tài nguyên cụ thể |
| benefit_headline | Thu hẹp phạm vi thiệt hại khi credential lộ hoặc quyền cấp sai, đồng thời chuẩn hóa phân quyền. |
| context_line | Áp dụng khi từ hai người hoặc hai dịch vụ trở lên cùng truy cập tài nguyên AWS; audit API khi đã bật CloudTrail và bảo vệ log theo chính sách. |

**teaching_points (khái niệm):** Bốn khái niệm User / Group / Role / Policy; Policy là tài liệu gắn principal; IAM Role cho workload và CI/CD, tránh access key tĩnh; least privilege và IAM Access Analyzer.

**value_for_operations:** Blast radius; onboarding/offboarding; CloudTrail (khi đã cấu hình trail); OIDC cho CI/CD (credential ngắn hạn).

**project_story:** Role CI/CD + prefix `releases/` (PutObject / multipart khi cần); Group staging + off-board; Access Analyzer trước audit; SCP cho tổ chức nhiều account.

---

### 2. EC2 — `slide_id: ec2`

| Field | Nội dung |
|--------|-----------|
| badge_label | EC2 |
| official_name | Amazon EC2 |
| friendly_title | Máy chủ ảo — tùy chỉnh và mở rộng theo tải |
| benefit_headline | Kiểm soát đầy đủ OS và runtime, scale theo traffic thay vì đầu tư phần cứng cố định trước. |
| context_line | Web server, worker nền, batch, bastion hoặc workload cần cài phần mềm đặc thù trên máy. |

**teaching_points:** Instance family `c`/`r`/`m`/`t` (burstable + credit); scale policy nên cân nhắc latency ALB / queue, không chỉ CPU; AMI chuẩn hóa; Security Group, tránh SSH/RDP `0.0.0.0/0` trên production.

**value_for_operations:** ASG + ALB; tách web/worker/bastion; AMI đồng nhất; CloudWatch (CPU, credit, status check).

**project_story:** Ví dụ ASG theo CPU (minh họa — tune thêm); AMI + userdata; bastion-only SSH; Session Manager thay SSH public (tùy mạng).

---

### 3. S3 — `slide_id: s3`

| Field | Nội dung |
|--------|-----------|
| badge_label | S3 |
| official_name | Amazon S3 |
| friendly_title | Kho object bền — file, static asset và artifact ở quy mô lớn |
| benefit_headline | Giảm tải I/O cho máy ứng dụng và tách lifecycle, chi phí theo từng loại dữ liệu. |
| context_line | Static asset, upload, artifact, backup; Object Lock khi cần immutability. |

**teaching_points:** Bucket + prefix; versioning; Object Lock (bắt buộc versioning; governance vs compliance); Lifecycle.

**value_for_operations:** Presigned URL; bucket tách staging/prod; versioning; replication (DR — chi phí/consistency theo docs).

**project_story:** Restore `config/settings.json`; artifact `git-sha`; lifecycle log; CloudFront + OAC/OAI cho static (pattern phổ biến).

---

### 4. Route 53 — `slide_id: dns`

| Field | Nội dung |
|--------|-----------|
| badge_label | DNS |
| official_name | Amazon Route 53 |
| friendly_title | Tên miền và điều hướng traffic tập trung |
| benefit_headline | DNS tập trung giúp migration và phản ứng sự cố nhanh hơn, bớt phụ thuộc nhiều nhà cung cấp rời rạc. |
| context_line | Hosted zone, health check, weighted/failover; chi tiết giá bản ghi và query xem bảng giá AWS. |

**teaching_points:** Hosted zone vs registrar; Alias / apex / giá Route 53; health check + failover; private hosted zone + hybrid DNS.

**value_for_operations:** TTL trước/sau cutover; quản lý tập trung; weighted/canary; health check có phí — lên kế hoạch.

**project_story:** TTL + Alias ALB; public không lộ instance; failover; API nội bộ qua private zone.

---

### 5. RDS — `slide_id: rds`

| Field | Nội dung |
|--------|-----------|
| badge_label | RDS |
| official_name | Amazon RDS (PostgreSQL) |
| friendly_title | PostgreSQL do AWS vận hành — tập trung dữ liệu và truy vấn |
| benefit_headline | Backup tự động, patch và chuyển đổi dự phòng do dịch vụ quản lý — team tập trung schema và hiệu năng query. |
| context_line | OLTP production; Aurora PostgreSQL khi cần scale đọc hoặc serverless phù hợp. |

**teaching_points:** Backup, PITR, major upgrade; Multi-AZ vs Read Replica; Blue/Green (một số engine — xem docs); snapshot.

**value_for_operations:** PITR; Parameter/Option Group; replica cho báo cáo; ReplicaLag / Performance Insights.

**project_story:** RDS major: snapshot + staging qua console/API — **không** nhầm với `pg_upgrade` trên EC2; restore/PITR; báo cáo trên replica; test parameter group + slow query trên staging.

---

### 6. Elastic Beanstalk — `slide_id: eb`

| Field | Nội dung |
|--------|-----------|
| badge_label | Elastic Beanstalk |
| official_name | AWS Elastic Beanstalk |
| friendly_title | Triển khai ứng dụng nhanh — không lắp từng máy tay |
| benefit_headline | Rút ngắn đường từ merge tới production nhờ ALB, Auto Scaling và health check có sẵn. |
| context_line | Web/API cần velocity; orchestration container phức tạp hơn thường xem ECS/EKS. |

**teaching_points:** Application / Version / Environment; AL2 vs AL2023; `.ebextensions` / `.platform` hooks; CI/CD deploy version.

**value_for_operations:** Blue/Green; Saved Configuration; CloudWatch Logs; X-Ray khi bật; EB là PaaS trên EC2, không phải serverless.

**project_story:** Nâng platform + swap; Saved Config; rollback bằng deploy lại version ổn định; secret/env qua console / SSM / Secrets Manager.

---

### 7. Sao lưu đa lớp — `slide_id: backup`

| Field | Nội dung |
|--------|-----------|
| badge_label | Sao lưu |
| official_name | Chiến lược sao lưu đa lớp |
| friendly_title | Bốn lớp: DB, object, cấu hình và secret |
| benefit_headline | Khi sự cố xảy ra, khôi phục theo playbook đã thử — không phụ thuộc trí nhớ cá nhân. |
| context_line | RPO/RTO riêng từng lớp; restore drill định kỳ. |

**teaching_points:** Bốn lớp; Parameter Store SecureString vs Secrets Manager; RPO/RTO; restore drill.

**value_for_operations:** MTTR; compliance; backup “có mà không restore”; sao lưu IaC (Terraform state, CloudFormation).

**project_story:** Checklist maintenance; drill RDS; rotation Secrets Manager; export IaC template để tái tạo hạ tầng.

---

### 8. Ngừng vận hành — `slide_id: lifecycle`

| Field | Nội dung |
|--------|-----------|
| badge_label | Ngừng vận hành |
| official_name | Quy trình tắt hệ thống an toàn |
| friendly_title | Sunset có thứ tự — không sót dữ liệu, không sót chi phí |
| benefit_headline | Đóng hệ thống theo checklist: tránh mất data, resource mồ côi vẫn tính phí và DNS trỏ nhầm. |
| context_line | Sau backup và verify: dọn compute/data, thu hồi quyền, DNS cuối cùng. |

**teaching_points:** Thứ tự gợi ý; khung linh hoạt (drain, legal hold); DNS cuối; tag + Resource Groups / AWS Config.

**value_for_operations:** Final snapshot; cost leak; CloudTrail khi bật; Cost Explorer sau 7–30 ngày.

**project_story:** Sunset checklist; NAT sót; maintenance DNS; dọn ACM/cert không dùng sau khi đổi DNS.

---

### 9. Tổng kết — `slide_id: summary`

| Field | Nội dung |
|--------|-----------|
| badge_label | Tổng kết |
| official_name | Nguyên tắc vận hành DevOps trên AWS |
| friendly_title | Từ danh sách dịch vụ đến văn hóa vận hành chung |
| benefit_headline | Công cụ đúng, quy trình rõ và tài liệu cập nhật giúp giảm panic lúc sự cố và tăng tốc phối hợp. |
| context_line | Runbook, on-call và postmortem bổ sung cho công cụ. |

**teaching_points:** You build it, you run it; tự động hóa + đo lường (SLI/SLO); backup và môi trường gần prod; runbook, ADR, postmortem.

**value_for_operations:** Incident checklist; onboarding; traceability; pipeline staging + test tự động.

**project_story:** Kiến trúc tham chiếu; runbook deploy; postmortem; owner + dashboard tối thiểu + runbook happy/failure path.

---

## Ghi chú kỹ thuật (cho dev)

- View: `app/views/home/_sliders.html.slim` — `slider.fetch(:ten_key)`.
- `teaching_points_html` và `project_story_examples_html` in bằng `==` (HTML tin cậy từ helper).
- `value_for_operations` in bằng `=` (escape).

---

## Thay đổi chính so với bản A (Claude) và B (ChatGPT)

- **Hợp nhất độ sâu và độ ngắn:** giữ insight kỹ thuật từ bản A; sau rà soát demo, **mở rộng** từng mảng lên **3–5 bullet** khi cần (OIDC, SCP, Session Manager, replication S3, private zone, Blue/Green RDS, IaC backup, Cost Explorer, CALMS/đo lường) — không bắt buộc cố định 3 ý.
- **Ngôn ngữ:** copy carousel ưu tiên **tiếng Việt**; `benefit_headline` / `context_line` gọn; thuật ngữ AWS giữ tiếng Anh chuẩn.
- **Chính xác AWS:** Multi-AZ ≠ read scaling; S3 prefix; Route 53 + giá/health check có điều kiện; RDS major qua **luồng RDS**, phân biệt `pg_upgrade` (EC2); CloudTrail/X-Ray khi đã bật; EB là PaaS trên EC2.
- **Nguồn chuẩn:** `home_helper.rb` là nguồn đầu; doc này tóm tắt — khi lệch, sửa helper rồi đồng bộ doc.
- **Tổng quan:** giữ mục kiến trúc tham chiếu và bảng field cho onboarding / đối ngoại.

---

*Cập nhật theo `HomeHelper#aws_sliders` trong repo.*
