import("lib.nas");
import("map.nas");
import("bp.nas");

rand(time(0));
var bp=bp_gen();
bp.init_from_file();
var max=func(vec)
{
    var maxnum=vec[0];
    foreach(var n;vec)
        if(maxnum<n)
            maxnum=n;
    return maxnum;
}
var run=func()
{
    var step=0;
    var score=0;
    # map gen
    var map=map_gen();

    # agent gen
    var cord=[int(rand()*5),int(rand()*5)];
    map.set(cord,1);

    # food cord
    map.set_food();

    for(var cnt=0;cnt<15;cnt+=1)
    {
        step+=1;
        var state=map.state();
        map.print();
        var change=
        [
            [cord[0],cord[1]-1],
            [cord[0],cord[1]+1],
            [cord[0]-1,cord[1]],
            [cord[0]+1,cord[1]]
        ];
        
        var Q_val=bp.forward(state);
        var (move,maxnum)=(0,Q_val[0]);
        for(var i=0;i<4;i+=1)
            if(Q_val[i]>maxnum)
            {
                move=i;
                maxnum=Q_val[i];
            }
        println(['w ','s ','a ','d '][move],' ',score);
        
        if(!map.score(change[move]))
            break;
        map.set(cord,0);
        cord=change[move];
        var val=map.get(cord);
        map.set(cord,1);
        if(val==-1) # eat food then add score and spwan new food
        {
            score+=1;
            cnt=0;
            map.set_food();
        }
    }
    return [score,step];
}
println(run());