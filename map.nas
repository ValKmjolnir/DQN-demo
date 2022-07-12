var mapsize=5;
var map_gen=func()
{
    var map_str="+";
    for(var i=0;i<mapsize;i+=1)
        map_str~="--";
    map_str~="+\n";

    var (food_x,food_y)=(0,0);
    var (agent_x,agent_y)=(0,0);
    var platform=os.platform();
    var _=[];
    setsize(_,mapsize);
    for(var y=0;y<mapsize;y+=1){
        _[y]=[];
        setsize(_[y],mapsize);
        for(var x=0;x<mapsize;x+=1)
            _[y][x]=0;
    }
    return
    {
        set:func(cord,val){
            if(val==1)
                (agent_x,agent_y)=cord;
            _[cord[1]][cord[0]]=val;
        },
        get:func(cord){
            return _[cord[1]][cord[0]];
        },
        state:func()
        {
            var (x,y)=(agent_x-food_x,agent_y-food_y);

            if(x==0)   x=1;
            elsif(x<0) x=0;
            else       x=2;

            if(y==0)   y=1;
            elsif(y<0) y=0;
            else       y=2;

            # why only this two arguments can be used as state?
            # try to think about it.
            return [x,y];

            # i optimized the state twice:
            # the first try, i use the whole map as the state,
            # it is really useful but it caused too much useless calculation.
            # the second try, i use this vector as the state.
            # here is a example that the food is at the lower right corner of the agent
            # [
            #     [0,0,0],
            #     [0,0,0],
            #     [0,0,1]
            # ];
            # here is a example that the food is at the lower left corner of the agent
            # [
            #     [0,0,0],
            #     [0,0,0],
            #     [1,0,0]
            # ];
            # this really saves lots of time training the Qnetwork.
            # however, it still can be optimized as a coordinates.
            # the example can be optimized as coordinates [2,2] and [0,2]
            # so the state is finally in this form
        },
        score:func(cord)
        {
            var (x,y)=cord;
            # wall  0
            if(x<0 or x>mapsize-1 or y<0 or y>mapsize-1)
                return 0;
            # (0)road  1 (1)self  0 (-1)apple 1
            return [1,0,1][_[y][x]];
        },
        set_agent:func()
        {
            (agent_x,agent_y)=(int(rand()*mapsize),int(rand()*mapsize));
            while(_[agent_y][agent_x]!=0)
                (agent_x,agent_y)=(int(rand()*mapsize),int(rand()*mapsize));
            _[agent_y][agent_x]=1;
            return [agent_x,agent_y];
        },
        set_food:func()
        {
            (food_x,food_y)=(int(rand()*mapsize),int(rand()*mapsize));
            while(_[food_y][food_x]!=0)
                (food_x,food_y)=(int(rand()*mapsize),int(rand()*mapsize));
            _[food_y][food_x]=-1;
        },
        print:func()
        {
            var ch=['  ','O ','* '];
            var s="\e[0;0H"~map_str;
            for(var y=0;y<mapsize;y+=1)
            {
                s~='|';
                for(var x=0;x<mapsize;x+=1)
                    s~=ch[_[y][x]];
                s~='|\n';
            }
            print(s~map_str);
            unix.sleep(1/100);
        }
    };
}
