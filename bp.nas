var exp=math.exp;
var tanh=func(x)
{
    var t=exp(2*x);
    return (t-1)/(t+1);
}
var sigmoid=func(x)
{
    return 1.0/(1+exp(-x));
}
var bp_gen=func()
{
    var (alpha,gamma)=(0.5,0.8);
    var (inum,hnum,onum)=(2,2,4);
    var (input,hidden,output)=([],[],[]);
    setsize(input,inum);
    setsize(hidden,hnum);
    setsize(output,onum);
    return
    {
        init_from_file:func()
        {
            var s=io.fin("agent.dat");
            s=split(' ',s);
            var index=0;
            for(var i=0;i<hnum;i+=1)
            {
                hidden[i]={w:[],bia:num(s[index]),in:0,out:0,diff:0};
                index+=1;
                setsize(hidden[i].w,inum);
                for(var j=0;j<inum;j+=1)
                {
                    hidden[i].w[j]=num(s[index]);
                    index+=1;
                }
            }
            for(var i=0;i<onum;i+=1)
            {
                output[i]={w:[],bia:num(s[index]),in:0,out:0,diff:0};
                index+=1;
                setsize(output[i].w,hnum);
                for(var j=0;j<hnum;j+=1)
                {
                    output[i].w[j]=num(s[index]);
                    index+=1;
                }
            }
        },
        output_file:func()
        {
            var s='';
            for(var i=0;i<hnum;i+=1)
            {
                s~=hidden[i].bia~' ';
                for(var j=0;j<inum;j+=1)
                    s~=hidden[i].w[j]~' ';
            }
            for(var i=0;i<onum;i+=1)
            {
                s~=output[i].bia~' ';
                for(var j=0;j<hnum;j+=1)
                    s~=output[i].w[j]~' ';
            }
            io.fout("agent.dat",s);
        },
        init:func()
        {
            for(var i=0;i<hnum;i+=1)
            {
                hidden[i]={w:[],bia:rand()<0.5?-rand():rand(),in:0,out:0,diff:0};
                setsize(hidden[i].w,inum);
                for(var j=0;j<inum;j+=1)
                    hidden[i].w[j]=(rand()<0.5?-rand():rand())/inum;
            }
            for(var i=0;i<onum;i+=1)
            {
                output[i]={w:[],bia:rand()<0.5?-rand():rand(),in:0,out:0,diff:0};
                setsize(output[i].w,hnum);
                for(var j=0;j<hnum;j+=1)
                    output[i].w[j]=(rand()<0.5?-rand():rand())/hnum;
            }
            return;
        },
        forward:func(state)
        {
            for(var i=0;i<inum;i+=1)
                input[i]=state[i];
            for(var i=0;i<hnum;i+=1)
            {
                hidden[i].in=hidden[i].bia;
                for(var j=0;j<inum;j+=1)
                    hidden[i].in+=input[j]*hidden[i].w[j];
                hidden[i].out=tanh(hidden[i].in);
            }
            for(var i=0;i<onum;i+=1)
            {
                output[i].out=output[i].bia;
                for(var j=0;j<hnum;j+=1)
                    output[i].out+=hidden[j].out*output[i].w[j];
            }
            var vec=[0,0,0,0];
            for(var i=0;i<onum;i+=1)
                vec[i]=output[i].out;
            return vec;
        },
        backward:func(move,reward,Qnext)
        {
            var expect=reward<0?0:(1-alpha)*output[move].out+alpha*(reward+gamma*Qnext);
            var ret=expect-output[move].out;
            for(var i=0;i<onum;i+=1)
                output[i].diff=0;
            output[move].diff=0.01*ret;
            for(var i=0;i<hnum;i+=1)
            {
                hidden[i].diff=0;
                for(var j=0;j<onum;j+=1)
                    hidden[i].diff+=output[j].w[i]*output[j].diff;
                hidden[i].diff*=1-hidden[i].out*hidden[i].out;
            }
            for(var i=0;i<onum;i+=1)
            {
                output[i].bia+=output[i].diff;
                for(var j=0;j<hnum;j+=1)
                    output[i].w[j]+=output[i].diff*hidden[j].out;
            }
            for(var i=0;i<hnum;i+=1)
            {
                hidden[i].bia+=hidden[i].diff;
                for(var j=0;j<inum;j+=1)
                    hidden[i].w[j]+=hidden[i].diff*input[j];
            }
            return 0.5*ret*ret;
        }
    };
}