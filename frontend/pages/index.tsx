import type { NextPage } from 'next';
import Head from 'next/head';
import Image from 'next/image';
import { ConnectButton } from '@rainbow-me/rainbowkit';
import { useAccount, useConnect } from 'wagmi';
import { Dialog } from '@headlessui/react';
import React, { MouseEventHandler, useEffect, useState } from 'react';
import { User } from '@supabase/supabase-js';
import { useRouter } from 'next/router';

import { supabase } from '../src/utils/SupabaseClient';
import Link from 'next/link';
import Header from '../components/Header';

const Home: NextPage = () => {
    // const { data } = useAccount();
    // const { isConnected } = useConnect();

    let [isOpen, setIsOpen] = useState(true);

    // const DisplayNameComp = () => {
    //     if (isConnected && data) {
    //         return <div>Your address is: {data.address}</div>;
    //     } else {
    //         return <></>;
    //     }
    // };

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
                router.push('/dashboard');
            } else {
                router.push('/signin');
            }
        };

        getProfile();
    }, []);

    if (!user) {
        // Currently loading asynchronously User Supabase Information
        return null;
    }

    return (
        <div className="flex flex-col h-screen">
            <Head>
                <title>Adadis</title>
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
                    {/* <button className="text-xl rounded-md border-2 p-4 border-black hover:bg-black hover:text-white">
                        Login / Signup
                    </button> */}
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
            <main className="flex-grow w-full bg-[url('/assets/adidas_simple.png')]">
                {/* Content
                <DisplayNameComp /> */}

                {/* <section className="w-full h-screen"> */}
                {/* <img
                    src="/assets/adidas_simple.png"
                    className="object-cover w-full h-full"
                    alt="Image alt text"
                /> */}

                <Dialog
                    open={isOpen}
                    onClose={() => setIsOpen(false)}
                    className="relative z-50"
                >
                    {/* The backdrop, rendered as a fixed sibling to the panel container */}
                    <div
                        className="fixed inset-0 bg-black/60"
                        aria-hidden="true"
                    />

                    {/* Full-screen container to center the panel */}
                    <div className="fixed inset-0 flex items-center justify-center p-4">
                        {/* The actual dialog panel  */}
                        <Dialog.Panel className="mx-auto w-2/6 rounded bg-white">
                            <Dialog.Title className="text-xl p-4">
                                Join the Adadis metaverse and parrticipate in
                                epic virtual competitions!
                            </Dialog.Title>
                            {/* <p>
                                Get free shipping, discount vouchers and members
                                only products when you’re in adiClub LOG IN OR
                                SIGN UP (ITS FREE) Enter your email to access or
                                create your account.
                            </p> */}
                            <div className="w-2/6 mx-auto my-8 text-2xl bg-blue-500 rounded-md p-4 text-center">
                                <ConnectButton
                                // chainStatus="none"
                                // showBalance={false}
                                // accountStatus="address"
                                />
                            </div>

                            {/* <button onClick={() => setIsOpen(false)}>
                                Deactivate
                            </button>
                            <button onClick={() => setIsOpen(false)}>
                                Cancel
                            </button> */}
                            {/* ... */}
                        </Dialog.Panel>
                    </div>
                </Dialog>

                {/* </section> */}
            </main>
            {/* <footer className="">Adiads original</footer> */}
            {/* <footer className="p-4 bg-blue-500">Footer</footer> */}
        </div>
    );
};

export default Home;
