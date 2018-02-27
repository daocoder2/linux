<div class="BlogAnchor">
   <p>
   <b id="AnchorContentToggle" title="收起" style="cursor:pointer;">目录[+]</b>
   </p>
   
  <div class="AnchorContent" id="AnchorContent"> </div>
</div>


# 工作日常总结

1、linux删除表文件：

find /usr/local/mysql/var/ -type f -name '*.txt' -print0 | xargs -i -0 rm -f {}

根据inode删除文件：

find  ./ -inum 139712405 | xargs rm -f