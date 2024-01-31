# Move Thumbnail for Orca Slicer

:warning: Use at your own risk :warning:


This Orca Slicer post-processing script moves the GCODE thumbnail data to the end of the file. The native option for this has not yet been pulled in from SuperSlicer, so this python script solves my annoyance. 

# How to use:
Make the script executable:
```
chmod +x thumbnail_move.py
```

Edit this path and add it to the Post Processing box.
```
/path/to/python3 /Users/cron410/3dp/thumbnail_move.py  
```

![Screen Shot 2024-01-31 at 1 40 25 PM](https://github.com/cron410/gcode_thumbnail_move/assets/3082899/5605f2eb-37d9-4d33-9d76-b54dca590a2d)
