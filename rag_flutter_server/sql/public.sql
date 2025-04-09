/*
 Navicat Premium Dump SQL

 Source Server         : 远程PostgresSQL
 Source Server Type    : PostgreSQL
 Source Server Version : 170004 (170004)
 Source Host           : 49.235.96.75:5432
 Source Catalog        : rag_flutter_db
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 170004 (170004)
 File Encoding         : 65001

 Date: 09/03/2025 17:36:47
*/


-- ----------------------------
-- Sequence structure for chat_contents_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."chat_contents_id_seq";
CREATE SEQUENCE "public"."chat_contents_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for file_info_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."file_info_id_seq";
CREATE SEQUENCE "public"."file_info_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for rag_sessions_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."rag_sessions_id_seq";
CREATE SEQUENCE "public"."rag_sessions_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for users_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."users_id_seq";
CREATE SEQUENCE "public"."users_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Table structure for chat_contents
-- ----------------------------
DROP TABLE IF EXISTS "public"."chat_contents";
CREATE TABLE "public"."chat_contents" (
  "id" int4 NOT NULL DEFAULT nextval('chat_contents_id_seq'::regclass),
  "content" text COLLATE "pg_catalog"."default",
  "is_user" bool,
  "created_at" timestamp(6),
  "session_id" varchar(50) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."chat_contents"."id" IS '主键';
COMMENT ON COLUMN "public"."chat_contents"."content" IS '聊天内容';
COMMENT ON COLUMN "public"."chat_contents"."is_user" IS '是否为用户内容';
COMMENT ON COLUMN "public"."chat_contents"."created_at" IS '创建时间';
COMMENT ON COLUMN "public"."chat_contents"."session_id" IS '会话id';
COMMENT ON TABLE "public"."chat_contents" IS '聊天内容记录表';

-- ----------------------------
-- Records of chat_contents
-- ----------------------------
INSERT INTO "public"."chat_contents" VALUES (3, '你是谁?', 't', '2025-03-07 00:34:06.334856', '8522cd39bd1341099031f4d502c48c3e');
INSERT INTO "public"."chat_contents" VALUES (4, '我是阿里云开发的一款超大规模语言模型，我叫通义千问。', 'f', '2025-03-07 00:34:06.334856', '8522cd39bd1341099031f4d502c48c3e');
INSERT INTO "public"."chat_contents" VALUES (5, '你的功能是什么?', 't', '2025-03-07 09:19:25.978225', '8522cd39bd1341099031f4d502c48c3e');
INSERT INTO "public"."chat_contents" VALUES (6, '我是来自阿里云的大规模语言模型，我叫通义千问。我的功能主要包括以下几个方面：

1. 文本生成：我可以根据给定的主题或关键词生成相关的文本内容。

2. 问答：我可以回答各种领域的问题，提供实用的信息和解决方案。

3. 翻译：我可以进行多语言之间的翻译，帮助跨越语言障碍。

4. 摘要：我可以从长篇文章中提取关键信息，生成简洁的摘要。

5. 对话：我可以参与对话交流，提供帮助和支持。

请注意，虽然我会不断学习和进步，但仍然可能存在一定的局限性。如果您有任何问题或需要帮助，请随时告诉我。', 'f', '2025-03-07 09:19:29.278419', '8522cd39bd1341099031f4d502c48c3e');
INSERT INTO "public"."chat_contents" VALUES (7, '请问Java是什么', 't', '2025-03-07 12:34:21.433447', '8522cd39bd1341099031f4d502c48c3e');
INSERT INTO "public"."chat_contents" VALUES (8, 'Java是一种广泛使用的编程语言和计算平台，由詹姆斯·高斯林（James Gosling）于1995年在Sun Microsystems（已被甲骨文公司收购）开发。Java的设计目的是让开发者“一次编写，到处运行”（Write Once, Run Anywhere），这意味着用Java编写的程序可以在任何支持Java的平台上运行，而无需重新编译。这一特性主要是通过Java虚拟机（JVM）实现的，它将Java字节码解释或编译成特定机器代码。

Java的特点包括：

1. **面向对象**：Java是基于面向对象的编程语言，这使得代码更易于维护、重用和理解。
2. **简单性**：Java设计时就考虑到了简单性，尽量避免了复杂的指针操作等底层概念。
3. **可移植性**：由于Java程序可以在任何安装了Java虚拟机（JVM）的设备上运行，因此具有很高的可移植性。
4. **健壮性**：Java提供了垃圾回收机制来管理内存，减少了内存泄漏等问题，增强了程序的健壮性。
5. **安全性**：Java内置了许多安全特性，如提供了一个安全模型来限制应用可以执行的操作。
6. **多线程**：Java原生支持多线程编程，这使得它可以轻松地进行并发处理，提高程序性能。
7. **动态性**：Java支持运行时的类加载和动态链接，这使得它非常适合分布式环境。

Java被广泛应用于企业级软件开发、Android应用程序开发、Web应用程序、桌面应用程序以及各种嵌入式系统等领域。', 'f', '2025-03-07 12:34:28.332979', '8522cd39bd1341099031f4d502c48c3e');
INSERT INTO "public"."chat_contents" VALUES (9, 'Dart是什么', 't', '2025-03-07 15:30:02.30594', 'aea0e0bede3b47759945a48338bea8cf');
INSERT INTO "public"."chat_contents" VALUES (10, 'Dart是一种由Google开发的客户端优化编程语言。它主要用于构建网络和移动应用程序，并且可以运行在任何平台上。Dart支持面向对象编程、不可变数据结构以及函数式编程风格。此外，它还具有一种称为"is"的操作符，用于检查一个对象是否为特定类型。

Dart可以通过Dart虚拟机在服务器端运行，或者被编译成JavaScript以在浏览器中运行。最著名的是，Dart被用来创建Flutter框架，这是一个用于构建跨平台移动应用的UI工具包。使用Dart和Flutter，开发者可以使用同一套代码库为Android、iOS、Windows、MacOS、Linux甚至Web构建应用程序。这使得Dart成为了一种非常灵活且强大的语言，特别适合于现代多平台应用程序的开发。', 'f', '2025-03-07 15:30:02.30594', 'aea0e0bede3b47759945a48338bea8cf');
INSERT INTO "public"."chat_contents" VALUES (11, 'gradle是什么', 't', '2025-03-07 15:46:44.106772', '8522cd39bd1341099031f4d502c48c3e');
INSERT INTO "public"."chat_contents" VALUES (12, 'Gradle 是一个基于Apache Ant和Apache Maven概念的项目自动化构建工具。它使用Groovy（一种运行在Java虚拟机上的动态语言）或Kotlin作为其构建脚本的语言。Gradle 被设计用来解决传统构建工具的一些问题，并且提供了一个灵活的、可扩展的框架来描述项目的构建过程。

以下是Gradle的一些主要特点：

1. **依赖管理**：Gradle自动管理项目依赖项，支持本地和远程仓库（如Maven Central和JCenter），使得添加和更新库变得非常容易。
   
2. **多项目构建**：Gradle允许将大型项目分割成多个子项目，每个子项目可以独立地进行构建。这有助于更好地组织代码，并且使大型项目的构建更加高效。
   
3. **灵活性**：通过使用Groovy或Kotlin DSL，用户可以定义复杂和自定义的构建逻辑，这比XML（如在Maven中）更加强大和灵活。
   
4. **增量构建**：Gradle只构建那些发生更改的部分，避免了不必要的重新编译，从而加快了构建速度。
   
5. **插件系统**：Gradle有一个强大的插件系统，允许开发者为自己的构建过程添加额外的功能，比如处理特定类型的资源文件或者集成第三方工具。

6. **集成测试与静态分析工具**：Gradle可以很容易地集成各种测试框架（如JUnit, TestNG等）以及静态代码分析工具（如Checkstyle, FindBugs等），以确保代码质量和稳定性。

由于这些优点，Gradle被广泛应用于Android应用开发、Java企业级应用开发以及其他多种软件项目的构建过程中。', 'f', '2025-03-07 15:46:52.141917', '8522cd39bd1341099031f4d502c48c3e');
INSERT INTO "public"."chat_contents" VALUES (13, '你是谁？', 't', '2025-03-07 15:48:57.129877', '8522cd39bd1341099031f4d502c48c3e');
INSERT INTO "public"."chat_contents" VALUES (14, '我是阿里云开发的一款超大规模语言模型，我叫通义千问。', 'f', '2025-03-07 15:48:58.362672', '8522cd39bd1341099031f4d502c48c3e');
INSERT INTO "public"."chat_contents" VALUES (17, '请根据文档说一下文档内容', 't', '2025-03-09 17:20:16.593768', 'aea0e0bede3b47759945a48338bea8cf');
INSERT INTO "public"."chat_contents" VALUES (18, '您提到的“文档”具体指什么内容呢？您能否提供一些更多的信息或上下文，这样我才能够更准确地为您提供相关信息。', 'f', '2025-03-09 17:20:17.688065', 'aea0e0bede3b47759945a48338bea8cf');
INSERT INTO "public"."chat_contents" VALUES (19, '人月神话主要说了什么', 't', '2025-03-09 17:24:16.681584', 'aea0e0bede3b47759945a48338bea8cf');
INSERT INTO "public"."chat_contents" VALUES (20, '《人月神话》是由Frederick P. Brooks Jr.撰写的一本关于软件工程的经典书籍。该书主要讨论了软件开发过程中的一些常见问题和挑战，并提出了相应的解决方案。

书中提出了一些重要的概念，例如"人月"的概念，指的是在软件项目中增加人员数量并不一定能够提高生产效率，有时甚至会导致效率下降。此外，书中还介绍了如何进行有效的团队协作、如何管理软件项目等经验教训。这些观点对于现代软件工程实践仍然具有很高的参考价值。', 'f', '2025-03-09 17:24:18.750234', 'aea0e0bede3b47759945a48338bea8cf');
INSERT INTO "public"."chat_contents" VALUES (21, '焦油坑是什么', 't', '2025-03-09 17:31:47.670886', '6180688ac03941748b5aba25e68330f6');
INSERT INTO "public"."chat_contents" VALUES (22, '焦油坑（Oil sands或Tar sands）是指含有大量重质原油的砂石混合物。这些天然资源通常富含粘稠的石油，由于其外观和颜色类似焦油而得名“焦油”。这种重质石油通常被称为沥青，它与沙子、黏土以及水等物质混合在一起。

焦油坑主要分布在世界上几个特定地区，最著名的包括加拿大的阿尔伯塔省、委内瑞拉的奥里诺科重油带（Orinoco Belt）以及俄罗斯的部分地区。其中，加拿大阿尔伯塔省的焦油砂资源尤其丰富，被认为是仅次于沙特阿拉伯的全球第二大原油储备地。

从焦油坑中提取石油的过程比传统油田的开采更为复杂且环境影响更大。由于沥青粘性极高，需要采用特殊的开采方法，如露天矿采掘或蒸汽辅助重力泄油（SAGD）等地下注热技术。这些方法不仅成本较高，而且在生产过程中可能会对环境造成负面影响，例如消耗大量水资源、产生温室气体排放以及破坏当地生态系统等。因此，焦油砂的开发一直是一个充满争议的话题。', 'f', '2025-03-09 17:31:47.670886', '6180688ac03941748b5aba25e68330f6');
INSERT INTO "public"."chat_contents" VALUES (23, '书里说的焦油坑是什么意思', 't', '2025-03-09 17:33:41.239631', 'aea0e0bede3b47759945a48338bea8cf');
INSERT INTO "public"."chat_contents" VALUES (24, '在《人月神话》这本书中，“焦油坑”（Tar pit）是一个比喻性的术语，用来形象地描述那些开发过程中遇到的复杂且难以解决的问题。就像动物陷入真正的焦油坑一样，开发人员一旦陷入这些问题，很难轻易脱身。焦油坑通常涉及技术债务、遗留系统维护、需求变更频繁等问题，这些问题会消耗大量的时间和资源，严重影响项目的进度和质量。书中通过这个比喻提醒读者要谨慎处理这类问题，避免项目因为这些问题而陷入困境。', 'f', '2025-03-09 17:33:43.117873', 'aea0e0bede3b47759945a48338bea8cf');
INSERT INTO "public"."chat_contents" VALUES (25, '这个对于我们有什么教训', 't', '2025-03-09 17:35:00.813152', 'aea0e0bede3b47759945a48338bea8cf');
INSERT INTO "public"."chat_contents" VALUES (26, '"焦油坑"这一比喻为软件开发提供了几个重要的教训：

1. **预防为主**：尽量避免技术债务的积累。这意味着在设计和实现阶段就要注重代码的质量和可维护性，及时修复bug和重构不合理的代码，以防止未来可能出现的复杂问题。

2. **评估成本**：在面对可能成为“焦油坑”的任务时，需要充分评估其开发和维护成本。这包括考虑长期的技术支持需求、潜在的风险以及对其他部分的影响。

3. **优先级管理**：识别哪些问题是真正关键的，哪些可以暂时搁置。对于那些可能会拖慢整个项目进程的难题，需要特别关注并寻找高效解决方案。

4. **敏捷迭代**：采用敏捷开发方法论可以帮助团队更好地应对变化，通过短周期迭代来逐步解决复杂问题，而不是一次性投入大量资源试图一劳永逸地解决问题。

5. **团队合作与沟通**：确保所有成员都清楚了解项目目标及面临的风险。加强内部沟通，鼓励知识共享，有助于集思广益找到更好的解决办法。

6. **风险管理**：制定风险管理计划，提前准备应对策略。当问题出现时，可以迅速响应并采取措施减轻影响。

通过这些教训，我们可以更加有效地管理和克服软件开发过程中遇到的各种挑战。', 'f', '2025-03-09 17:35:04.335539', 'aea0e0bede3b47759945a48338bea8cf');

-- ----------------------------
-- Table structure for chat_sessions
-- ----------------------------
DROP TABLE IF EXISTS "public"."chat_sessions";
CREATE TABLE "public"."chat_sessions" (
  "user_id" int4 NOT NULL,
  "session_id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "name" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."chat_sessions"."user_id" IS '用户id';
COMMENT ON COLUMN "public"."chat_sessions"."session_id" IS '大模型多轮对话的 session_id';
COMMENT ON COLUMN "public"."chat_sessions"."name" IS '聊天记录名';
COMMENT ON TABLE "public"."chat_sessions" IS '聊天会话表';

-- ----------------------------
-- Records of chat_sessions
-- ----------------------------
INSERT INTO "public"."chat_sessions" VALUES (7, '8522cd39bd1341099031f4d502c48c3e', '2025-03-07 00:34:06.265321', '旧聊天');
INSERT INTO "public"."chat_sessions" VALUES (7, 'aea0e0bede3b47759945a48338bea8cf', '2025-03-07 15:30:02.10289', '新聊天');
INSERT INTO "public"."chat_sessions" VALUES (7, '6180688ac03941748b5aba25e68330f6', '2025-03-09 17:31:47.571636', '新聊天');

-- ----------------------------
-- Table structure for file_info
-- ----------------------------
DROP TABLE IF EXISTS "public"."file_info";
CREATE TABLE "public"."file_info" (
  "id" int4 NOT NULL DEFAULT nextval('file_info_id_seq'::regclass),
  "file_id" varchar(50) COLLATE "pg_catalog"."default",
  "file_name" varchar(50) COLLATE "pg_catalog"."default",
  "rag_id" int4,
  "created_at" timestamp(6)
)
;
COMMENT ON COLUMN "public"."file_info"."id" IS '主键id';
COMMENT ON COLUMN "public"."file_info"."file_id" IS '大模型上传文件后返回的文件id';
COMMENT ON COLUMN "public"."file_info"."file_name" IS '文件名';
COMMENT ON COLUMN "public"."file_info"."rag_id" IS '知识库id';
COMMENT ON COLUMN "public"."file_info"."created_at" IS '创建时间';
COMMENT ON TABLE "public"."file_info" IS '文件信息表';

-- ----------------------------
-- Records of file_info
-- ----------------------------
INSERT INTO "public"."file_info" VALUES (3, 'file_428d9174cd48462191e27ca64e8ce7a5_11300526', '人月神话.pdf', 4, '2025-03-09 16:54:29.998931');

-- ----------------------------
-- Table structure for rag_sessions
-- ----------------------------
DROP TABLE IF EXISTS "public"."rag_sessions";
CREATE TABLE "public"."rag_sessions" (
  "id" int4 NOT NULL DEFAULT nextval('rag_sessions_id_seq'::regclass),
  "user_id" int4 NOT NULL,
  "pipeline_id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "rag_name" varchar(255) COLLATE "pg_catalog"."default",
  "description" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."rag_sessions"."pipeline_id" IS '大模型知识库的 pipeline_id';
COMMENT ON COLUMN "public"."rag_sessions"."rag_name" IS '知识库名称';
COMMENT ON COLUMN "public"."rag_sessions"."description" IS '知识库描述';
COMMENT ON TABLE "public"."rag_sessions" IS 'RAG 知识库会话表，仅记录 pipeline_id，不存知识库文档';

-- ----------------------------
-- Records of rag_sessions
-- ----------------------------
INSERT INTO "public"."rag_sessions" VALUES (4, 7, 'buarsgs2u4', '2025-03-09 16:51:42.898718', '人月', '11111');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS "public"."users";
CREATE TABLE "public"."users" (
  "id" int4 NOT NULL DEFAULT nextval('users_id_seq'::regclass),
  "username" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "password" text COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(6) DEFAULT CURRENT_TIMESTAMP
)
;
COMMENT ON COLUMN "public"."users"."id" IS '用户ID，主键，自增';
COMMENT ON COLUMN "public"."users"."username" IS '用户名，唯一';
COMMENT ON COLUMN "public"."users"."password" IS '用户密码（建议存储加密哈希值）';
COMMENT ON COLUMN "public"."users"."created_at" IS '用户注册时间，默认为当前时间';
COMMENT ON TABLE "public"."users" IS '用户表，存储应用用户的账号信息';

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO "public"."users" VALUES (1, '111111', '111111', '2025-03-05 15:05:53.108427');
INSERT INTO "public"."users" VALUES (2, '1111', '1111', '2025-03-05 15:11:03.207164');
INSERT INTO "public"."users" VALUES (3, '11111', '1111', '2025-03-05 15:24:20.553272');
INSERT INTO "public"."users" VALUES (4, 'zhangsan', '1111', '2025-03-05 15:25:38.233926');
INSERT INTO "public"."users" VALUES (5, 'lisi', '11111', '2025-03-05 15:42:28.223725');
INSERT INTO "public"."users" VALUES (6, 'qqqq', '11111', '2025-03-05 15:47:47.738924');
INSERT INTO "public"."users" VALUES (7, 'test', 'test', '2025-03-05 16:19:33.588109');

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."chat_contents_id_seq"
OWNED BY "public"."chat_contents"."id";
SELECT setval('"public"."chat_contents_id_seq"', 26, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."file_info_id_seq"
OWNED BY "public"."file_info"."id";
SELECT setval('"public"."file_info_id_seq"', 3, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."rag_sessions_id_seq"
OWNED BY "public"."rag_sessions"."id";
SELECT setval('"public"."rag_sessions_id_seq"', 4, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."users_id_seq"
OWNED BY "public"."users"."id";
SELECT setval('"public"."users_id_seq"', 7, true);

-- ----------------------------
-- Primary Key structure for table chat_contents
-- ----------------------------
ALTER TABLE "public"."chat_contents" ADD CONSTRAINT "chat_contents_pk" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table chat_sessions
-- ----------------------------
ALTER TABLE "public"."chat_sessions" ADD CONSTRAINT "chat_sessions_session_id_key" UNIQUE ("session_id");

-- ----------------------------
-- Primary Key structure for table chat_sessions
-- ----------------------------
ALTER TABLE "public"."chat_sessions" ADD CONSTRAINT "chat_sessions_pkey" PRIMARY KEY ("session_id");

-- ----------------------------
-- Primary Key structure for table file_info
-- ----------------------------
ALTER TABLE "public"."file_info" ADD CONSTRAINT "file_info_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table rag_sessions
-- ----------------------------
ALTER TABLE "public"."rag_sessions" ADD CONSTRAINT "rag_sessions_pipeline_id_key" UNIQUE ("pipeline_id");

-- ----------------------------
-- Primary Key structure for table rag_sessions
-- ----------------------------
ALTER TABLE "public"."rag_sessions" ADD CONSTRAINT "rag_sessions_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table users
-- ----------------------------
ALTER TABLE "public"."users" ADD CONSTRAINT "users_username_key" UNIQUE ("username");

-- ----------------------------
-- Primary Key structure for table users
-- ----------------------------
ALTER TABLE "public"."users" ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Keys structure for table chat_sessions
-- ----------------------------
ALTER TABLE "public"."chat_sessions" ADD CONSTRAINT "chat_sessions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table rag_sessions
-- ----------------------------
ALTER TABLE "public"."rag_sessions" ADD CONSTRAINT "rag_sessions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
