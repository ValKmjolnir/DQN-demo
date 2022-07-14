import.map; # map module
import.bp;  # bp network

rand(time(0));
var bp=bp_gen();   # generate bp
bp.init_from_file();# get network state from file

var run=func(){
    var (score,step)=(0,0);
    # map gen
    var map=map_gen();
    # agent gen
    var cord=map.set_agent();
    # food cord
    map.set_food();

    for(var cnt=0;cnt<15;cnt+=1){
        step+=1;
        var state=map.state();
        map.print();
        if(score>=1000){ # score 1000 to win the game
            print("you win!\n");
            break;
        }
        var change=[
            [cord[0],cord[1]-1],
            [cord[0],cord[1]+1],
            [cord[0]-1,cord[1]],
            [cord[0]+1,cord[1]]
        ];
        
        var Q_val=bp.forward(state);
        var (move,maxnum)=(0,Q_val[0]);
        for(var i=0;i<4;i+=1)
            if(Q_val[i]>maxnum)
                (move,maxnum)=(i,Q_val[i]);
        print(['w','s','a','d'][move],' ',score,'\n');
        
        if(!map.score(change[move])){ # hit wall
            print("hit\n");
            break;
        }
        map.set(cord,0);
        cord=change[move];
        var val=map.get(cord);
        map.set(cord,1);
        if(val==-1){ # eat food then add score and spwan new food
            score+=1;
            cnt=0;
            map.set_food();
        }
    }
    return [score,step];
}

print("\ec");
var (score,step)=run();
print("score ",score," in ",step," step(s)\n");