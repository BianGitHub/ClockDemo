# ClockDemo
clock / 时钟 / 简易钟表 / 带时,分,秒针 / 锚点的使用

时钟Demo的原理是根据layer的锚点去旋转, 基本思路为设置时,分,秒针的锚点进行旋转指定的角度;


-->难点为 "锚点" 的理解以及 角度计算

1.首先说下锚点: 锚点就是定位点, 默认取值为(0.5,0.5); 取值范围是0~1;

              锚点决定了layer身上的哪个位置停在了position上;
              
              position是相对父layer来说的一个位置
              
              例如:(0.5,0.5)就是中心点在layer的position上
              
              
 2.对于计算来说, 首先需要获取系统时间, 设置好初始角度, 也就是当前的时间, 然后根据旋转角度
 
    秒针就是表盘分成60格---> 每一秒转的角度为: M_PI *2 / 60
    
    分针也是表盘分成60格, 需要注意的是, 秒针转一圈, 分针走一格, 即每秒钟分针走的角度为:M_PI *2 / 60 / 60
    
    时针原理同分针, 其中不同的是分针是分成了12格, M_PI *2 / 60 / 12
    
    
    旋转的角度需要注意: 分针旋转的角度是: (系统获取的时间的角度) + (秒针已经走的时间, 分针需要走的角度)
                      时针同理
                      
                                       
 -->其中涉及到 定时器:
 
          CADisplayLink定时器精度要比NSTimer稍微精确;
          
          CADisplayLink与屏幕的刷新率保持一致 每秒60次, 所以在刷新方法中需要 /60;
          
          如果精度要求不是很高, 也可选择NSTimer! 
          
          
    
          
    
