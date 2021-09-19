import("lib.nas");
import("map.nas");
import("bp.nas");

rand(time(0));
var bp=bp_gen();
var replay=[];
var data_gen=func()
{
    bp.init();
    bp.output_file();
}
var init_from_file=bp.init_from_file;
var max=func(vec)
{
    var maxnum=vec[0];
    foreach(var n;vec)
        if(maxnum<n)
            maxnum=n;
    return maxnum;
}
var training=func()
{
    var t_set=nil;
    var Qnext=0;
    # map gen
    var map=map_gen();

    # agent gen
    var cord=[int(rand()*5),int(rand()*5)];
    map.set(cord,1);

    # food cord
    map.set_food();

    for(var cnt=0;cnt<100;cnt+=1)
    {
        var state=map.state();
        var change=
        [
            [cord[0],cord[1]-1],# w
            [cord[0],cord[1]+1],# s
            [cord[0]-1,cord[1]],# a
            [cord[0]+1,cord[1]] # d
        ];
        
        var Q_val=bp.forward(state);
        var (move,maxnum)=(0,Q_val[0]);
        forindex(var i;Q_val)
            if(Q_val[i]>maxnum)
            {
                move=i;
                maxnum=Q_val[i];
            }
        if(rand()<0.2)
            move=int(rand()*4);
        
        if(!map.score(change[move]))
        {
            append(replay,[state,move,state,-1]);
            Qnext=max(bp.forward(state));
            bp.forward(state);
            bp.backward(move,-1,Qnext);
            break;
        }

        map.set(cord,0);
        cord=change[move];
        var val=map.get(cord);
        map.set(cord,1);
        if(val==-1) # eat food then add score and spwan new food
        {
            cnt=0;
            map.set_food();
        }
        var next_state=map.state();
        append(replay,[state,move,next_state,val==-1?10:0]);
        Qnext=max(bp.forward(next_state));
        bp.forward(state);
        bp.backward(move,val==-1?10:0,Qnext);

        for(var r=0;r<10;r+=1)
        {
            t_set=replay[int(rand()*size(replay))];
            Qnext=max(bp.forward(t_set[2]));
            bp.forward(t_set[0]);
            bp.backward(t_set[1],t_set[3],Qnext);
        }
    }
    return;
}
var auto=func(loop)
{
    replay=[];
    for(var i=0;i<loop;i+=1)
    {
        training();
        print('\r      \r',100*(i+1)/loop,'%');
    }
    print('\rreplaying: ',size(replay),' avg step: ',size(replay)/loop,'\n');
    bp.output_file();
    return;
}
data_gen();
init_from_file();
for(var i=0;i<30;i+=1)
    auto(100);
#print('\n');