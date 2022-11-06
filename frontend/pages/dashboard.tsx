import type { NextPage } from 'next';
import Head from 'next/head';
import { ConnectButton } from '@rainbow-me/rainbowkit';
import { useAccount, useConnect, useSigner, useProvider } from 'wagmi';
import React, { MouseEventHandler, useEffect, useState } from 'react';
import { User } from '@supabase/supabase-js';
import { useRouter } from 'next/router';
import * as EpnsAPI from '@pushprotocol/restapi';

import { supabase } from '../src/utils/SupabaseClient';
import Link from 'next/link';

const Home: NextPage = () => {
    const { data } = useAccount();
    const { isConnected } = useConnect();

    const DisplayNameComp = () => {
        if (isConnected && data) {
            return <span>Your wallet is connected!</span>;
        } else {
            return <></>;
        }
    };

    const router = useRouter();
    const [user, setUser] = useState<User | null>();

    const handleLogOut: MouseEventHandler = async (e) => {
        e.preventDefault();

        const { error } = await supabase.auth.signOut();

        if (error) {
            alert(JSON.stringify(error));
        } else {
            router.push('/signin');
        }
    };

    useEffect(() => {
        const getProfile = async () => {
            const {
                data: { user },
            } = await supabase.auth.getUser();

            if (user) {
                setUser(user);
            } else {
                router.push('/signin');
            }
        };

        getProfile();
    }, []);

    useEffect(() => {
        if (isConnected == true && user) {
            fetch('https://ethsf-backend.abion.xyz/enrich_user_data', {
                method: 'POST',
                headers: {
                    Accept: 'application/json',
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    email: user?.email,
                    wallet_address: data?.address,
                }),
            })
                .then((response) => response.json())
                .then((response) => console.log(JSON.stringify(response)));
        }
    }, [isConnected, data, user]);

    if (!user) {
        // Currently loading asynchronously User Supabase Information
        return null;
    }

    const optInChannel = async () => {
        if (typeof window.ethereum !== 'undefined') {
            // @ts-ignore
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            const signer = provider.getSigner();

            await EpnsAPI.channels.subscribe({
                // @ts-ignore
                signer: signer,
                channelAddress:
                    'eip155:5:0xD8634C39BBFd4033c0d3289C4515275102423681', // channel address in CAIP
                userAddress:
                    'eip155:5:0x52f856A160733A860ae7DC98DC71061bE33A28b3', // user address in CAIP
                onSuccess: () => {
                    console.log('opt in success');
                },
                onError: () => {
                    console.error('opt in error');
                },
                env: 'staging',
            });
        }
    };

    return (
        <div className="flex flex-col h-screen">
            <Head>
                <title>adidas</title>
                <meta name="description" content="Adadis" />
                <link rel="icon" href="/favicon.ico" />
            </Head>
            <header className="pt-4 pb-2 bg-white flex flex-row justify-between items-center ">
                <div className="pl-4">
                    <Link href="/">
                        <a>
                            <img
                                src="/assets/adadis_logo_small.png"
                                className="object-cover w-24"
                                alt="background image"
                            />
                        </a>
                    </Link>
                </div>
                <div className="flex flex-row justify-between w-1/5">
                    <div className="text-xl font-bold">Men</div>
                    <div className="text-xl font-bold">Women</div>
                    <div className="text-xl font-bold">Kids</div>
                    <div>Gifts</div>
                    <div>Sale</div>
                </div>
                <div>
                    <div className="text-2xl p-4 font-bold border-black">
                        Hello Jan
                    </div>
                    {/* <ConnectButton */}
                    {/* // chainStatus="none"
                    // showBalance={false}
                    // accountStatus="address"
                    /> */}
                </div>
            </header>
            <main className="flex-grow w-full bg-[url('/assets/clean_background.png')] bg-cover">
                <div className="p-6">
                    <div className="text-center text-4xl font-bold text-white">
                        Welcome to the adidas Metaverse!
                    </div>
                    <div className="text-center text-2xl text-white">
                        Solve challenges, become part of the team and earn cool
                        rewards.
                    </div>
                </div>

                <div className="grid grid-cols-2 mx-auto w-4/5 justify-between gap-y-48 items-stretch">
                    <div className="bg-white/20 rounded-md border-2 w-4/5 mx-auto  h-full">
                        <div className="bg-white text-3xl">
                            #1 Getting Started
                        </div>
                        <div className="p-4">
                            <div className="text-white text-xl">
                                First connect your wallet and to receive your
                                membership pass to adadis!
                            </div>
                            <div className="mt-4">
                                <ConnectButton
                                    // chainStatus="none"
                                    showBalance={false}
                                    accountStatus="address"
                                />
                                <div className="text-green-900 font-bold mt-2">
                                    <DisplayNameComp />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="bg-white/20 rounded-md border-2 w-4/5 mx-auto  h-full">
                        <div className="bg-white text-3xl">
                            #2 Show you are real
                        </div>

                        <div className="p-4">
                            <div className="text-white text-xl">
                                Proof that you are a real human to prevent spam
                                on our platform
                            </div>
                            <div className="mt-4">
                                <a
                                    href={`https://developer.worldcoin.org/hosted/wid_staging_1d09eac19217b79f35ddc97853b29680?signal=${data?.address}`}
                                >
                                    <button className="rounded-md flex flex-row items-center bg-white p-2">
                                        <img
                                            src="/assets/worldcoin_logo.png"
                                            className="object-cover w-8"
                                            alt=""
                                        />
                                        <div>Verify with worldcoin</div>
                                    </button>
                                </a>
                            </div>
                        </div>
                    </div>

                    <div className="bg-white/20 rounded-md border-2 w-4/5 mx-auto h-full">
                        <div className="bg-white text-3xl">#3 Join the fam</div>
                        <div className="p-4">
                            <div className="text-white text-xl">
                                Follow us on twitter and don`t miss future
                                updates!
                            </div>
                            <div className="mt-2 flex flex-row items-center justify-around">
                                <div>
                                    <a
                                        href="https://twitter.com/ETHGlobal?ref_src=twsrc%5Etfw"
                                        className="twitter-follow-button"
                                        data-show-count="false"
                                    >
                                        Follow @Adidas
                                    </a>
                                    <script
                                        async
                                        src="https://platform.twitter.com/widgets.js"
                                        charSet="utf-8"
                                    ></script>
                                </div>
                                <div>
                                    <button
                                        type="button"
                                        className="inline-block p-2 text-white text-xs font-semibold rounded flex flex-row items-center bg-purple-600"
                                        // style={{
                                        //     'background-color': '#7289da',
                                        // }}
                                    >
                                        <div>
                                            <svg
                                                xmlns="http://www.w3.org/2000/svg"
                                                viewBox="0 0 640 512"
                                                className="w-4 h-4"
                                            >
                                                <path
                                                    fill="currentColor"
                                                    d="M524.531,69.836a1.5,1.5,0,0,0-.764-.7A485.065,485.065,0,0,0,404.081,32.03a1.816,1.816,0,0,0-1.923.91,337.461,337.461,0,0,0-14.9,30.6,447.848,447.848,0,0,0-134.426,0,309.541,309.541,0,0,0-15.135-30.6,1.89,1.89,0,0,0-1.924-.91A483.689,483.689,0,0,0,116.085,69.137a1.712,1.712,0,0,0-.788.676C39.068,183.651,18.186,294.69,28.43,404.354a2.016,2.016,0,0,0,.765,1.375A487.666,487.666,0,0,0,176.02,479.918a1.9,1.9,0,0,0,2.063-.676A348.2,348.2,0,0,0,208.12,430.4a1.86,1.86,0,0,0-1.019-2.588,321.173,321.173,0,0,1-45.868-21.853,1.885,1.885,0,0,1-.185-3.126c3.082-2.309,6.166-4.711,9.109-7.137a1.819,1.819,0,0,1,1.9-.256c96.229,43.917,200.41,43.917,295.5,0a1.812,1.812,0,0,1,1.924.233c2.944,2.426,6.027,4.851,9.132,7.16a1.884,1.884,0,0,1-.162,3.126,301.407,301.407,0,0,1-45.89,21.83,1.875,1.875,0,0,0-1,2.611,391.055,391.055,0,0,0,30.014,48.815,1.864,1.864,0,0,0,2.063.7A486.048,486.048,0,0,0,610.7,405.729a1.882,1.882,0,0,0,.765-1.352C623.729,277.594,590.933,167.465,524.531,69.836ZM222.491,337.58c-28.972,0-52.844-26.587-52.844-59.239S193.056,219.1,222.491,219.1c29.665,0,53.306,26.82,52.843,59.239C275.334,310.993,251.924,337.58,222.491,337.58Zm195.38,0c-28.971,0-52.843-26.587-52.843-59.239S388.437,219.1,417.871,219.1c29.667,0,53.307,26.82,52.844,59.239C470.715,310.993,447.538,337.58,417.871,337.58Z"
                                                />
                                            </svg>
                                        </div>
                                        <div className="ml-2">Join Discord</div>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="bg-white/20 rounded-md border-2 w-4/5 mx-auto h-full">
                        <div className="bg-white text-3xl">
                            #4 Join the chat
                        </div>
                        <div className="p-4">
                            <div className="text-white text-xl">
                                Join a vibrate community of virtual alethets.
                                Events are first announced here.
                            </div>
                            <a href="https://staging.push.org/#/channels">
                                <button className="rounded-md flex flex-row items-center bg-white p-2 mt-4">
                                    <img
                                        src="/assets/push_logo.png"
                                        className="object-cover w-8"
                                        alt=""
                                    />
                                    <div>Subscribe to channel</div>
                                </button>
                            </a>
                        </div>
                    </div>
                </div>
                <div className="text-center mt-24">
                    <button className="rounded-md text-white text-3xl p-4 bg-blue-900 hover:bg-white hover:text-black">
                        Enter the metaverse
                    </button>
                </div>
                {/* Content
                <DisplayNameComp /> */}

                {/* <section className="w-full h-screen"> */}
                {/* <img
                    src="/assets/adidas_simple.png"
                    className="object-cover w-full h-full"
                    alt="Image alt text"
                /> */}

                {/* </section> */}
            </main>
            {/* <footer className="">Adiads original</footer> */}
            {/* <footer className="p-4 bg-blue-500">Footer</footer> */}
        </div>
    );
};

export default Home;
