# environment:
# 1<->2
# 1<->4
# 2<->3
# 4<->3
# 2->2
# 4->4
# 3->3
var R=[
    [-1,0,-1,0], # s1->a1 a2 a3 a4
    [0,0,10,-1], # s2->a1 a2 a3 a4
    [-1,0,10,0], # s3->a1 a2 a3 a4
    [0,-1,10,0]  # s4->a1 a2 a3 a4
];
# this R means Reward
var Q=[
    [0,0,0,0],# s1->a1 a2 a3 a4
    [0,0,0,0],# s2->a1 a2 a3 a4
    [0,0,0,0],# s3->a1 a2 a3 a4
    [0,0,0,0] # s4->a1 a2 a3 a4
];
# this is Q table
var maxindex=func(vec){
    var (mindex,maxnum)=(0,vec[0]);
    forindex(var i;vec)
        if(maxnum<vec[i]){
            mindex=i;
            maxnum=vec[i];
        }
    return mindex;
}
var maxnum=func(vec){
    var num=vec[0];
    foreach(var i;vec)
        if(num<i)
            num=i;
    return num;
}

var (alpha,gamma)=(1,0.8);
var train=func(){
    var state=0;
    for(var i=0;i<100;i+=1){
        var next_state=maxindex(Q[state]);
        if(rand()<0.2)
            next_state=int(rand()*4);
        if(R[state][next_state]<0){
            Q[state][next_state]=0;
            break;
        }
        Q[state][next_state]=
            (1-alpha)*Q[state][next_state]
            +alpha*(R[state][next_state]+gamma*maxnum(Q[next_state]));
        state=next_state;
    }
    return;
}

rand(time(0));
for(var i=0;i<1000;i+=1)# need more training,1000 is enough
    train();
foreach(var i;Q)
    println(i);
for(var i=0;i<4;i+=1){
    var t=maxindex(Q[i]);
    println(i+1,'->',t+1);
    # state transfer result
}