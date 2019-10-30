@echo off
hexo clean && hexo g && gulp && rsync -avzz --delete public ubuntu@49.232.144.49:/home/ubuntu/
pause