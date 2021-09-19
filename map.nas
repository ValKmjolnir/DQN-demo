var map_gen=func()
{
    var _=[];
    setsize(_,5);
    for(var y=0;y<5;y+=1)
    {
        _[y]=[];
        setsize(_[y],5);
        for(var x=0;x<5;x+=1)
            _[y][x]=0;
    }
    return
    {
        set:func(cord,val){_[cord[1]][cord[0]]=val;},
        get:func(cord){return _[cord[1]][cord[0]];},
        state:func()
        {
            var vec=[];
            for(var y=0;y<5;y+=1)
                for(var x=0;x<5;x+=1)
                    append(vec,_[y][x]);
            return vec;
        },
        score:func(cord)
        {
            var (x,y)=cord;
            # wall  0
            if(x<0 or x>4 or y<0 or y>4)
                return 0;
            # (0)road  1 (1)self  0 (-1)apple 1
            return [1,0,1][_[y][x]];
        },
        set_food:func()
        {
            var (x,y)=(int(rand()*5),int(rand()*5));
            while(_[y][x]!=0)
                (x,y)=(int(rand()*5),int(rand()*5));
            _[y][x]=-1;
            return;
        },
        print:func()
        {
            system("cls");
            var ch=['  ','O ','* '];
            var s='------------\n';
            for(var y=0;y<5;y+=1)
            {
                s~='|';
                for(var x=0;x<5;x+=1)
                    s~=ch[_[y][x]];
                s~='|\n';
            }
            print(s~'------------\n');
        }
    };
}
