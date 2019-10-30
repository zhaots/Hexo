---
title: Mysql恢复单个表数据
date: 2018-06-12 11:00:00
categories: 
    - Mysql
tags:
    - Mysql
---

## <font color='#5CACEE'>简介</font>
> 在MySQL dba的日常实际工作中，一个实例下有多个库，而我们常见的备份就是全库备份，有些同学经常会误操作删除多条记录，那我们的全备就派上用场了，通过以下实例来恢复被误删的数据~
<!-- more -->


## <font color='#5CACEE'>环境</font>
> 现在模拟恢复单个表的数据 先删除一个表： tb_kc
```
mysql> drop table tb_kc;
Query OK, 0 rows affected (0.01 sec)
```

### <font color='#CDAA7D'>从全备份中提取出该表的建表语句</font>

```
sed -e'/./{H;$!d;}' -e 'x;/CREATE TABLE `user_online`/!d;q' ajj_train.sql

CREATE TABLE `tb_kc` (
  `KC_ID` bigint(22) NOT NULL AUTO_INCREMENT,
  `KC_TITLE` varchar(255) DEFAULT NULL,
  `KC_TYPE` varchar(255) DEFAULT NULL,
  `DEPART_POSITION` varchar(255) DEFAULT NULL,
  `READING_TYPE` int(11) DEFAULT NULL,
  `UPLOAD_TIME` datetime DEFAULT NULL,
  `KC_CONTENT` longtext,
  `KC_FILE` varchar(255) DEFAULT NULL,
  `KC_STATE` varchar(2) DEFAULT NULL,
  `CREATER` varchar(255) DEFAULT NULL,
  `CREATERID` varchar(255) DEFAULT NULL,
  `CREATETIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `KC_TIME` bigint(22) DEFAULT NULL,
  `KC_INTEGRAL` bigint(22) DEFAULT NULL,
  `KC_HERD` varchar(2) DEFAULT NULL,
  `KC_IMG` varchar(255) DEFAULT NULL,
  `KC_TIME_LIMIT` datetime DEFAULT NULL,
  `exam_id` bigint(22) DEFAULT NULL,
  `create_org_id` int(11) DEFAULT '1',
  `elective_course` int(11) DEFAULT '0' COMMENT '0：必修课，1：选修课',
  `word_content` mediumtext,
  `link_url` varchar(255) DEFAULT NULL,
  `position_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`KC_ID`),
  UNIQUE KEY `SYS_C00125149` (`KC_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=184 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
```

### <font color='#CDAA7D'>得到了tb_kc创建的sql将其保存到sql文件中</font>

```
sed -e'/./{H;$!d;}' -e 'x;/CREATE TABLE `user_online`/!d;q' ajj_train.sql  > tb_kc.sql
```



### <font color='#CDAA7D'>提取该表的insert into语句</font>

```
grep -i 'INSERT INTO `tb_kc`'  ajj_train.sql >> tb_kc.sql 
```

>这里提取的就是之前所有插入做的操作,会把数据全部提取出来.

```
INSERT INTO `tb_kc` VALUES 
(183,'烟花爆竹安全培训','93',NULL,1,'2018-06-11 10:57:23',
'烟花爆竹安全培训题库','',NULL,'管理员','1','2018-06-11 02:57:23',86400,10,NULL,'/
style/img/pdf.png','2018-08-31 00:00:00',NULL,1,NULL,'<p style=\"margin: 20px 0px; text-align: center; text-indent: 32px; line-height: normal;\">
<span style=\"font-size: 16px;\"><strong><span style=\"font-family: 宋体; color: rgb(34, 34, 34);\">烟花爆竹安全培训题库</span>
</strong><strong><span style=\"font-family: 宋体; color: rgb(34, 34, 34);\"></span></strong>
</span></p><p style=\"margin: 20px 0px; text-align: center; text-indent: 32px; line-height: normal;\"><span style=\"font-size: 16px;\"><strong><span style=\"font-size: 16px; font-family: 仿宋_GB2312; color: rgb(34, 34, 34);\">
第一章&nbsp; 烟花爆竹安全管理基础知识测试题</span></strong><strong><span style=\"font-size: 16px; font-family: 仿宋_GB2312; color: rgb(34, 34, 34);\"></span></strong></span></p><p style=\"line-height: normal;\"><span style=\"font-size: 16px;\"><strong>
<span style=\"font-size: 16px; font-family: 仿宋_GB2312; color: rgb(34, 34, 34);\">
一、判断题</span></strong><strong><span style=\"font-size: 16px; font-family: 仿宋_GB2312; color: rgb(34, 34, 34);\">
</span></strong></span></p><p style=\"line-height: normal;\">
<span style=\"font-family: 仿宋_GB2312; color: rgb(34, 34, 34); font-size: 16px;\">1、烟花爆竹是以烟花药为主要原料制成，引燃后通过燃烧或爆炸，产生光、声、色、型、烟雾等效果，用于观赏，具有易燃易爆危险的物品。
```

### <font color='#CDAA7D'>得到了tb_kc插入的所有数据将其保存到sql文件中</font>



```
grep -i 'INSERT INTO `tb_kc`'  ajj_train.sql >> tb_kc.sql 
这里一定要追加到刚才创建表的sql中
```

### <font color='#CDAA7D'>将tb_kc的sql文件恢复到数据库中</font>

```
mysql -uajj_train -p ajj_train < tb_kc.sql
```

>在数据库中查询可以看到这条数据已经恢复了~