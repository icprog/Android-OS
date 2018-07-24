  
##############################################################
#3711/3716/3511/3516/336/358
PRODUCT_PROPERTY_OVERRIDES +=persist.cs.fp.chips=3516

#true:allow samespace enroll   flase: not allow samespace enroll
PRODUCT_PROPERTY_OVERRIDES +=persist.cs.fp.samespace_enroll=false

#true:allow repeat finger enroll   flase: not allow repeat finger enroll
PRODUCT_PROPERTY_OVERRIDES +=persist.cs.fp.repeat_enroll=false

#enroll_count:6~15
PRODUCT_PROPERTY_OVERRIDES +=persist.cs.fp.enroll_count=12

#true:allow to report key
PRODUCT_PROPERTY_OVERRIDES +=persist.cs.fp.key_support=true

#true:support navigation  (358 not support)
PRODUCT_PROPERTY_OVERRIDES +=persist.cs.fp.navigation=false

#true:only report up/down key (if true then singleclick/doubeclick/longtouch/navgation  function will disable)
PRODUCT_PROPERTY_OVERRIDES +=persist.cs.fp.down_up_click=false

#false:only disable singleclick key report
PRODUCT_PROPERTY_OVERRIDES +=persist.cs.fp.singleclick=true

#false:only disable doubleclick key report
PRODUCT_PROPERTY_OVERRIDES +=persist.cs.fp.doubleclick=true

#false:only disable longtouch key report
PRODUCT_PROPERTY_OVERRIDES +=persist.cs.fp.longtouch=true

#setting Ms between singleclick:200~500
PRODUCT_PROPERTY_OVERRIDES +=persist.cs.fp.doubleclick.time=300

#setting touch (500~800)Ms to report longtouch key
PRODUCT_PROPERTY_OVERRIDES +=persist.cs.fp.longtouch.time=500

#touch key table (should __setbit in fingerprint driver)
PRODUCT_PROPERTY_OVERRIDES +=persist.cs.fp.key.singleclick=87
PRODUCT_PROPERTY_OVERRIDES +=persist.cs.fp.key.doubleclick=64
PRODUCT_PROPERTY_OVERRIDES +=persist.cs.fp.key.longtouch=63
PRODUCT_PROPERTY_OVERRIDES +=persist.cs.fp.key.up=65
PRODUCT_PROPERTY_OVERRIDES +=persist.cs.fp.key.down=66
PRODUCT_PROPERTY_OVERRIDES +=persist.cs.fp.key.left=67
PRODUCT_PROPERTY_OVERRIDES +=persist.cs.fp.key.right=68
PRODUCT_PROPERTY_OVERRIDES +=persist.cs.fp.key.down_and_up=189




